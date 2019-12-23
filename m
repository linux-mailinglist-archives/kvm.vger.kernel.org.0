Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C34F129AB9
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 21:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbfLWUKf (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 15:10:35 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:33997 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726884AbfLWUKe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 15:10:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1577131833;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0qtXzJ7ZTRR2+SWknxQLJ4Je16nI1/Qg+c9ZI9bZMqQ=;
        b=OVMG9VsscSa7gz+2VBYHBFB0AC29jM84iszTqq1fDAF+Us5ps3D0QbjQrzGvCWEbdQ3nrb
        xZ1nLrO0C9oNXoKnElaRQTi/CCdTdLUl+YxTnM7FcJqHTCbMT/rnwtl2T7gvpFmIjzZ2F1
        p/UXW89rSQl+a2K3Uv6BXLtuswdJ/t8=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-fpgJ_HRNPnKGElYJPJp1QA-1; Mon, 23 Dec 2019 15:10:28 -0500
X-MC-Unique: fpgJ_HRNPnKGElYJPJp1QA-1
Received: by mail-qk1-f197.google.com with SMTP id m13so4894450qka.9
        for <kvm@vger.kernel.org>; Mon, 23 Dec 2019 12:10:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0qtXzJ7ZTRR2+SWknxQLJ4Je16nI1/Qg+c9ZI9bZMqQ=;
        b=ChcRd9jNkqMVqASndqj7vnMPBA7/TRw87FqvYKdnFgpDA4M5/CrBWYSOkDtlV3+DuW
         RpgdlmPzNv/UyZ/bl8RMILsepN01u8AQ5cYIMRDMzIBJWIqKn95+lOLibpjisaxfAQVA
         Trrvm8I8eHgX8T2gNPmwBatjhak2xZ/1/axS9ew9zpehj38H42fgHCrxvhBDoJVSGdPt
         0eS4oj1hNEAdSggu9pzehCN7TVnfzIpV4mAiCPnbPKk+aLDDl4RLFkMkDkUboi1rUvM0
         qjh99maZkLLCgHnB0vmcsI2NtU1zZoZ8gcjJPd5wy29WyRwisygvho1QKjLA3W7oAMvM
         KWdw==
X-Gm-Message-State: APjAAAVfqXkYrzToWT7/+J1qqMF9WyOa8bOUtXznBsbZ1CXOvpxggCp3
        z9kmQEm6MxqVe1qAGLMT6+OoaBm/2+eQiu3Rf2AenDTGz1u6pP433GbIMRbEDrEw4CtAt51ySod
        gYmhxXlWRuBWk
X-Received: by 2002:ac8:5143:: with SMTP id h3mr4271604qtn.144.1577131827223;
        Mon, 23 Dec 2019 12:10:27 -0800 (PST)
X-Google-Smtp-Source: APXvYqz8EPclLzs35Mazg0q7YeuMs7p5oxoosgwsGt+91CmWfu3wCXNiWspQrkNOv4zJ1zMg5qVOsA==
X-Received: by 2002:ac8:5143:: with SMTP id h3mr4271587qtn.144.1577131827021;
        Mon, 23 Dec 2019 12:10:27 -0800 (PST)
Received: from xz-x1 ([104.156.64.74])
        by smtp.gmail.com with ESMTPSA id o9sm6120558qko.16.2019.12.23.12.10.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Dec 2019 12:10:25 -0800 (PST)
Date:   Mon, 23 Dec 2019 15:10:24 -0500
From:   Peter Xu <peterx@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Christophe de Dinechin <dinechin@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Subject: Re: [PATCH RESEND v2 03/17] KVM: X86: Don't track dirty for
 KVM_SET_[TSS_ADDR|IDENTITY_MAP_ADDR]
Message-ID: <20191223201024.GB90172@xz-x1>
References: <20191221014938.58831-1-peterx@redhat.com>
 <20191221014938.58831-4-peterx@redhat.com>
 <cf232ce8-bc07-0192-580f-d08736980273@redhat.com>
 <20191223172737.GA81196@xz-x1>
 <851bd9ed-3ff3-6aef-725c-b586d819211c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <851bd9ed-3ff3-6aef-725c-b586d819211c@redhat.com>
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Dec 23, 2019 at 06:59:01PM +0100, Paolo Bonzini wrote:
> On 23/12/19 18:27, Peter Xu wrote:
> > Yes.  Though it is a bit tricky in that then we'll also need to make
> > sure to take slots_lock or srcu to protect that hva (say, we must drop
> > that hva reference before we release the locks, otherwise the hva
> > could gone under us, iiuc).
> 
> Yes, kvm->slots_lock is taken by x86_set_memory_region.  We need to move
> that to the callers, of which several are already taking the lock (all
> except vmx_set_tss_addr and kvm_arch_destroy_vm).

OK, will do.  I'll directly replace the x86_set_memory_region() calls
in kvm_arch_destroy_vm() to be __x86_set_memory_region() since IIUC
the slots_lock is helpless when destroying the vm... then drop the
x86_set_memory_region() helper in the next version.  Thanks,

-- 
Peter Xu

