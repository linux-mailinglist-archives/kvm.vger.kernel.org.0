Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27114D0D53
	for <lists+kvm@lfdr.de>; Wed,  9 Oct 2019 13:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbfJILA1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 9 Oct 2019 07:00:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44976 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725953AbfJILA1 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 9 Oct 2019 07:00:27 -0400
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com [209.85.221.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4F7452BF73
        for <kvm@vger.kernel.org>; Wed,  9 Oct 2019 11:00:27 +0000 (UTC)
Received: by mail-wr1-f70.google.com with SMTP id i14so929436wro.19
        for <kvm@vger.kernel.org>; Wed, 09 Oct 2019 04:00:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9UqErDD43mG5SKxbp+McxigQPLmUudq5RASPl2m5uPA=;
        b=Warn3Z2Yzfg5o+R9h8jRC5j1Ks8YZThOiTkHPwr19Ro/ik+0Qy/kMfT9ACVu1eAPfH
         xisFKUh+Fuq9vnluXtji/xW8vT8rw+5G8qfco/+JgBJOuf3qdmsVcAJrOzb1dZwYVP0X
         odkhefXrFCkFhDgnaXi6K0fIb/NxACTTe6R+kdWVhCdO7B6zqXK3jZ7i/58dPTgikevb
         HmIs9xLF38oc74+GwWIuq7qjJka9OTDZeEx2l2fTMVf5r3DIe3mrPZvDdpuGUPwKRqxn
         oGuTQm0+mQQh9RX1OMPikA5vh3/hDtsxKVE3GLTLohxpGsCUQ66XzcmQrYemwbTQWN53
         NFlw==
X-Gm-Message-State: APjAAAU81keonFPfoeq9eUdFNps8S6ZzPEuxlXNF2kVpWsANYV7u5e3j
        PJ1PpbSFZ2b+I41klNNHaA0xfu4FROoAjhJK4BmyrIlHFeXCFtt8OtjnjBNYGdlHagoe3ECxZ6t
        1X4osnYvb5Hq8
X-Received: by 2002:a1c:7311:: with SMTP id d17mr2011543wmb.49.1570618825894;
        Wed, 09 Oct 2019 04:00:25 -0700 (PDT)
X-Google-Smtp-Source: APXvYqweL8Kb0PbyoP7eI4TqxXo2aLMgPodvhxLW/eM5SrCLDlTwol4G+3OmyXdf6S62kdmehbv0lw==
X-Received: by 2002:a1c:7311:: with SMTP id d17mr2011527wmb.49.1570618825635;
        Wed, 09 Oct 2019 04:00:25 -0700 (PDT)
Received: from [192.168.10.150] ([93.56.166.5])
        by smtp.gmail.com with ESMTPSA id c17sm2489079wrc.60.2019.10.09.04.00.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Oct 2019 04:00:25 -0700 (PDT)
Subject: Re: [PATCH v2 7/8] KVM: x86: Add helpers to test/mark reg
 availability and dirtiness
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Reto Buerki <reet@codelabs.ch>,
        Liran Alon <liran.alon@oracle.com>
References: <20190927214523.3376-1-sean.j.christopherson@intel.com>
 <20190927214523.3376-8-sean.j.christopherson@intel.com>
 <87d0fi3zai.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Openpgp: preference=signencrypt
Message-ID: <f874f2c0-2f9f-935b-fc4f-2b70a5b5520a@redhat.com>
Date:   Wed, 9 Oct 2019 13:00:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <87d0fi3zai.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/09/19 11:32, Vitaly Kuznetsov wrote:
>> +static inline void kvm_register_mark_dirty(struct kvm_vcpu *vcpu,
>> +					   enum kvm_reg reg)
>> +{
>> +	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_avail);
>> +	__set_bit(reg, (unsigned long *)&vcpu->arch.regs_dirty);
>> +}
>> +
> Personal preference again, but I would've named this
> "kvm_register_mark_avail_dirty" to indicate what we're actually doing
> (and maybe even shortened 'kvm_register_' to 'kvm_reg_' everywhere as I
> can't see how 'reg' could be misread).
> 

I think this is okay, a register can be either not cached, available or
dirty.  But dirty means we have to write it back, so it implies
availability.

Paolo
