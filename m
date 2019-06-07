Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA10B392A3
	for <lists+kvm@lfdr.de>; Fri,  7 Jun 2019 19:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731060AbfFGRAM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jun 2019 13:00:12 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35940 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729241AbfFGRAM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jun 2019 13:00:12 -0400
Received: by mail-wm1-f68.google.com with SMTP id u8so2612613wmm.1
        for <kvm@vger.kernel.org>; Fri, 07 Jun 2019 10:00:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XXAq2Klvp8XRtyN/5cpRbSDfkXDz8FeqLRqLpjN+hiQ=;
        b=as6yStahGfACyIRQoVg55+dcyqwVLsR87vAg4qdYFK/FgnGhkXQho6DtCYuYERq8Vb
         oQVDAaFvRCxZn6titlKLLog24wkyZumtj/NuK1E2Iyf0dXNAwvsNAS14CpVj7Yk6FRbi
         LwkV4K2a8dSVA+EqD6INTM03r3ygkRQT2Rzk7jo1IrBXCGPGX3UUiFxZ8sRCBmBwnqG8
         SYIvFFaJnKkt5dKKsJDXiupkyYn2ehD2ooNo47NViaYPejceLjKlK3gOutcJBO+9yDHf
         gYM2z0JdHj9iAYA6y+W6Fl6HhLm+kMcXJe7J8BZWFJtKapqtNQkuTGiroa6FDhRAJX7d
         KzRQ==
X-Gm-Message-State: APjAAAUdR8XKB2qvYfJm3XJmv86s0gi/pPz64ge86AsUDG49RRK9wiq0
        0lEYwL2GYz5asGDo2J7HyPkr6A==
X-Google-Smtp-Source: APXvYqyNlMjuLjAWGP7Jq4CviMlJIcNTkvnXQX49IBUMX8daTaYo3E9RbXmeXrDqG+VwN8Nbs5ydqw==
X-Received: by 2002:a1c:7604:: with SMTP id r4mr4438734wmc.89.1559926810537;
        Fri, 07 Jun 2019 10:00:10 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:657f:501:149f:5617? ([2001:b07:6468:f312:657f:501:149f:5617])
        by smtp.gmail.com with ESMTPSA id y133sm4128877wmg.5.2019.06.07.10.00.07
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Fri, 07 Jun 2019 10:00:09 -0700 (PDT)
Subject: Re: [PATCH 06/15] KVM: nVMX: Don't "put" vCPU or host state when
 switching VMCS
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        kvm@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>,
        Liran Alon <liran.alon@oracle.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
References: <20190507160640.4812-1-sean.j.christopherson@intel.com>
 <20190507160640.4812-7-sean.j.christopherson@intel.com>
 <79ac3a1c-8386-3f5a-2abd-eb284407abb7@redhat.com>
 <20190606185727.GK23169@linux.intel.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <10df352d-d90b-8594-cc1c-5a5f8df689f7@redhat.com>
Date:   Fri, 7 Jun 2019 19:00:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190606185727.GK23169@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 06/06/19 20:57, Sean Christopherson wrote:
> What about taking the vmcs pointers, and using old/new instead of
> prev/cur?  Calling it prev is wonky since it's pulled from the current
> value of loaded_cpu_state, especially since cur is the same type.
> That oddity is also why I grabbed prev before setting loaded_vmcs,
> it just felt wrong even though they really are two separate things.
> 
> static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
> 				     struct loaded_vmcs *old,
> 				     struct loaded_vmcs *new)

I had it like that in the beginning actually.  But the idea of this
function is that because we're switching vmcs's, the host register
fields have to be moved to the VMCS that will be used next.  I don't see
how it would be used with old and new being anything other than
vmx->loaded_cpu_state and vmx->loaded_vmcs and, because we're switching
VMCS, those are the "previously" active VMCS and the "currently" active
VMCS.

What would also make sense, is to change loaded_cpu_state to a bool (it
must always be equal to loaded_vmcs anyway) and make the prototype
something like this:

static void vmx_sync_vmcs_host_state(struct vcpu_vmx *vmx,
				     struct loaded_vmcs *prev)


I'll send a patch.

Paolo
