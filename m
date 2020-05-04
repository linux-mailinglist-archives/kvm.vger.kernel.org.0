Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90D4F1C40C5
	for <lists+kvm@lfdr.de>; Mon,  4 May 2020 19:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729907AbgEDRG7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 4 May 2020 13:06:59 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:32471 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729880AbgEDRG7 (ORCPT
        <rfc822;kvm@vger.kernel.org>); Mon, 4 May 2020 13:06:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588612017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qM6cBcDrv7XvtKNZfJ9tygW5NlSD4IQZrqyuCyi/QkE=;
        b=GPY1Wbuqc/jJIfG5fxx4WVf8y7LltsTHhtbGdNk36F1oLrPHYAcy57rpXETwxbycFy77gZ
        lHberMU4uas//dTEMBoHnvw6Ce2paPoc4+rAWU7+/P7OLDT5maW/nc/5tmlY6wb2eCjtFQ
        munquh0Eyf1Txj0XUZgeAGWJZpd1g9w=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-474-XM11uJQNOuOeheZw2i3ZbQ-1; Mon, 04 May 2020 13:06:56 -0400
X-MC-Unique: XM11uJQNOuOeheZw2i3ZbQ-1
Received: by mail-wm1-f72.google.com with SMTP id q5so120187wmc.9
        for <kvm@vger.kernel.org>; Mon, 04 May 2020 10:06:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qM6cBcDrv7XvtKNZfJ9tygW5NlSD4IQZrqyuCyi/QkE=;
        b=AVt69D17QWsFOQFCmwnsjIo/VpTifZUtB46kV2NstZ5gsvB5EEPiKmdtUXHzv7Dihc
         Iz/OLqK7lOKBmO2luBSUFpiw0Yd5QzrClEMfqMh1wueJJji8XQRk99URKiqH1hy19fWv
         0N6BQOQ8sSZ4vT9xjSW2mNexAa4X+sVILasQr20w9rhsc5uaDB79nXerdKgmPpIyDMlR
         ALqYrITo8L3mSX4eNnJmgKoJawnkoJ6yl8laTt6pd7Tv3KmtNV4/WHT5y4j4MO8/ZuV2
         SQMmjKXY4aesxmZGOSnPUn5J6YIafH79ubHVJWndlNDzlGfIi9mZsHJe1yhwghM/ByWa
         r2HA==
X-Gm-Message-State: AGi0PuZ/H9uyYOarPeevCdc/ZAZRAfHmKf0P+DzhVORp03rEPk8+rPj3
        D3Zc9SeFF3r87X2ou52YroGyNPpqXtZ0JxGJhoj7+lBS/x9QHivxp5xIdwAFmlJfVS2cPTK7g9d
        UB3eGwx9eqwXH
X-Received: by 2002:a1c:c302:: with SMTP id t2mr16273723wmf.85.1588612014738;
        Mon, 04 May 2020 10:06:54 -0700 (PDT)
X-Google-Smtp-Source: APiQypLCobPwEfAYjjdMh4VD49vcI+LbaenE5QaeltpkG+Q9TXPlbUuum+mLzyOuaiLQN9CRB9k2yA==
X-Received: by 2002:a1c:c302:: with SMTP id t2mr16273705wmf.85.1588612014488;
        Mon, 04 May 2020 10:06:54 -0700 (PDT)
Received: from [192.168.178.58] ([151.20.132.175])
        by smtp.gmail.com with ESMTPSA id r2sm94839wmg.2.2020.05.04.10.06.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 10:06:53 -0700 (PDT)
Subject: Re: [PATCH v4 2/7] KVM: X86: Enable fastpath when APICv is enabled
To:     Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <kernellwp@gmail.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>,
        Haiwei Li <lihaiwei@tencent.com>
References: <1588055009-12677-1-git-send-email-wanpengli@tencent.com>
 <1588055009-12677-3-git-send-email-wanpengli@tencent.com>
 <87a72tf67l.fsf@vitty.brq.redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <906b09e3-edcf-9d0e-e43b-ae77741c55e9@redhat.com>
Date:   Mon, 4 May 2020 19:06:53 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <87a72tf67l.fsf@vitty.brq.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 30/04/20 15:34, Vitaly Kuznetsov wrote:
>>  static enum exit_fastpath_completion vmx_exit_handlers_fastpath(struct kvm_vcpu *vcpu)
>>  {
>> -	if (!is_guest_mode(vcpu)) {
>> +	if (!is_guest_mode(vcpu) && vcpu->arch.apicv_active) {
>>  		switch (to_vmx(vcpu)->exit_reason) {
>>  		case EXIT_REASON_MSR_WRITE:
>>  			return handle_fastpath_set_msr_irqoff(vcpu);
> I think that apicv_active checks are specific to APIC MSRs but
> handle_fastpath_set_msr_irqoff() can handle any other MSR as well. I'd
> suggest to move the check inside handle_fastpath_set_msr_irqoff().
> 
> Also, enabling Hyper-V SynIC leads to disabling apicv. It it still
> pointless to keep fastpath enabled?

Indeed, only fast paths that only apply to apicv should be disabled (and
ideally there should be a WARN_ON in the code that doesn't support !apicv).

Paolo

