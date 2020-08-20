Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFE2424BA5D
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 14:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729727AbgHTMF7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 08:05:59 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39104 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730352AbgHTJ6s (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 20 Aug 2020 05:58:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597917527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t8lvvw/yYxKRmz+hdWa2YvTezmPK88L9XFePRdHjAeE=;
        b=UFEeVnKfiyhT+nLdQ6pjJYWn2q135LQaRv+HpdQyx+3Y2N3XVARHE3hMby6shW5zvZ5/AO
        MslKa0U4nSYbEzMDDGVY42YyZ3v43HyFhclhSFdAlW/PsfND47/fb5JRZaLqx3LutmaAIN
        K2o4CmbsQ0ffyK7YpP62HQwxakU3Yz4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-e9b3nTbcNKCwQLZQZxmQvw-1; Thu, 20 Aug 2020 05:58:45 -0400
X-MC-Unique: e9b3nTbcNKCwQLZQZxmQvw-1
Received: by mail-wr1-f70.google.com with SMTP id o10so468402wrs.21
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 02:58:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t8lvvw/yYxKRmz+hdWa2YvTezmPK88L9XFePRdHjAeE=;
        b=LKli0o9U5no3SW7xAp+GsQTmw96QKLB6cOuqae/3I2wNKYZ7rSBKeonrMDCeMcbLEY
         KJ0X4MHQCeL0lYEJlbFfc/JaPhXC5ouuljVbJJl1xvBmFxpHDkbwJly1vXdyU54qab2T
         ksqqwbSjAkP/r3AtcDlA0LJ3SvYNUnSZM2g6rhRBkVJT32ce5DF3dwWmbLdpyRVUVQxl
         MaPD/A50zM8PTDjvGGZ1ZksJpiEQMDVOkd7lFsV1UM9qvVvrHyyB+KIKwx5KF9sDDyzY
         VEdde8I3MMbN0elb7900YiXF6ylaNuNgMMObgYjhHcb7z41lSszWvN9rnQEWJVUcIp9W
         fXAQ==
X-Gm-Message-State: AOAM530Sr8YW8oZA+eKtbO36WewoQykeZGDFn4P8rYHEVr2opabgcZZ0
        +J0YIRFB9wx1GPAdlyWwZQnf8mZQMFj+4sGh1ipNkJdgBBZMgnlTV1dWzi4D9zk8d+RfVvufbZg
        Yjm96EyzIDbi9
X-Received: by 2002:a7b:c00c:: with SMTP id c12mr2892897wmb.54.1597917524020;
        Thu, 20 Aug 2020 02:58:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxQG2uYPWfBztaiUxqZyq+dbAAl1wn0Yf6pusnnn3jC/iiRZELY2R1ZcTSp/HyzwfQlSLGT+Q==
X-Received: by 2002:a7b:c00c:: with SMTP id c12mr2892879wmb.54.1597917523784;
        Thu, 20 Aug 2020 02:58:43 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1cc0:4e4e:f1a9:1745? ([2001:b07:6468:f312:1cc0:4e4e:f1a9:1745])
        by smtp.gmail.com with ESMTPSA id t14sm3517781wrg.38.2020.08.20.02.58.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 02:58:43 -0700 (PDT)
Subject: Re: [PATCH 5/8] KVM: nSVM: implement ondemand allocation of the
 nested state
To:     Maxim Levitsky <mlevitsk@redhat.com>, kvm@vger.kernel.org
Cc:     Jim Mattson <jmattson@google.com>, Joerg Roedel <joro@8bytes.org>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
References: <20200820091327.197807-1-mlevitsk@redhat.com>
 <20200820091327.197807-6-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <476eecc8-a861-203c-40f5-46707d8c0237@redhat.com>
Date:   Thu, 20 Aug 2020 11:58:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200820091327.197807-6-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/08/20 11:13, Maxim Levitsky wrote:
> @@ -3912,6 +3914,14 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>  	vmcb_gpa = GET_SMSTATE(u64, smstate, 0x7ee0);
>  
>  	if (guest) {
> +		/*
> +		 * This can happen if SVM was not enabled prior to #SMI,
> +		 * but guest corrupted the #SMI state and marked it as
> +		 * enabled it there
> +		 */
> +		if (!svm->nested.initialized)
> +			return 1;
> +
>  		if (kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map) == -EINVAL)
>  			return 1;

This can also happen if you live migrate while in SMM (EFER.SVME=0).
You need to check for the SVME bit in the SMM state save area, and:

1) triple fault if it is clear

2) call svm_allocate_nested if it is set.

Paolo

