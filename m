Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC6424BAE7
	for <lists+kvm@lfdr.de>; Thu, 20 Aug 2020 14:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730315AbgHTMUE (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 20 Aug 2020 08:20:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:25599 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730041AbgHTJzn (ORCPT
        <rfc822;kvm@vger.kernel.org>); Thu, 20 Aug 2020 05:55:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597917335;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jf8gbz8LQopQe0J21yTGM4+cDZmGtIYLJCcRhjeOrR4=;
        b=UB4G3768jo311kVvi91ndf8WfkCNMZI0tbXGq94FtxVsP8v2k57IQdp9rXawNzfXycdsrR
        Ky9khbVd45mCsiJU8FeR5vbqQJY0WD/Aw5AUYNUs7400yyDhEDClZV1kjysdWmPkV4qAfS
        IIbp6yYYv0FFw1YxUEY+k8tnypVF118=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-579-MrWQtmR8Nee15c2Sc4PEoA-1; Thu, 20 Aug 2020 05:55:33 -0400
X-MC-Unique: MrWQtmR8Nee15c2Sc4PEoA-1
Received: by mail-wr1-f71.google.com with SMTP id f7so468928wrs.8
        for <kvm@vger.kernel.org>; Thu, 20 Aug 2020 02:55:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Jf8gbz8LQopQe0J21yTGM4+cDZmGtIYLJCcRhjeOrR4=;
        b=gDPvwJNVlr/GK+SPkK3GT8WPknWCC7Xij12IRAKekz/9jCiXgbb6tGaBHKQfResfbD
         rHfokUlmAnWQjEZ9a9ojkbxNSiW4OdNfB+DX+oxWzpIC8OLf1KN8wz6eD1NQYDYNabqC
         jfLgoC5DNmsRdHLIZIxTVgVV5sV8xuBfY583c0pkidiaULDQM70PgJZOK1n07qG5Gzw7
         CanuUSVkIuEs2IZFLtcsLbNrtvNJKyKVzkyedca92aL4DCP5QMzlDAdurjweRKLclKLR
         q5lKVO6Yt/vfpqcN2S8FgsvUCMLb6HGm9aur+OjUVVy4NXTYuVDirgjci+zlX5wBAgT1
         iqvg==
X-Gm-Message-State: AOAM532EBvssiI1bIbaZ5k1WndAZQGUHLZu7qbA6fFQdiuDjPFZ1TRvC
        cKs3FqSqZ/fawj9Had/TYf4fY30mksGBtuSUZ7FimPamN1vdea6pVImJKzSFgVHUPePd7aN2xUh
        VLiv1TOKxa06h
X-Received: by 2002:a1c:e244:: with SMTP id z65mr2712576wmg.34.1597917332844;
        Thu, 20 Aug 2020 02:55:32 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz7+uOoYVXeIwgWOAsbxvSNBUeYTbpN+9/M9HQCIj4IkWFjHWhPfBPnCwQmglmYgMwvO0mang==
X-Received: by 2002:a1c:e244:: with SMTP id z65mr2712561wmg.34.1597917332571;
        Thu, 20 Aug 2020 02:55:32 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:1cc0:4e4e:f1a9:1745? ([2001:b07:6468:f312:1cc0:4e4e:f1a9:1745])
        by smtp.gmail.com with ESMTPSA id g145sm4323729wmg.23.2020.08.20.02.55.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2020 02:55:32 -0700 (PDT)
Subject: Re: [PATCH 8/8] KVM: nSVM: read only changed fields of the nested
 guest data area
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
 <20200820091327.197807-9-mlevitsk@redhat.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <766e669d-9b0b-aad6-b1d2-19ef77cbb791@redhat.com>
Date:   Thu, 20 Aug 2020 11:55:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200820091327.197807-9-mlevitsk@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 20/08/20 11:13, Maxim Levitsky wrote:
> diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
> index 06668e0f93e7..f0bb7f622dca 100644
> --- a/arch/x86/kvm/svm/svm.c
> +++ b/arch/x86/kvm/svm/svm.c
> @@ -3924,7 +3924,7 @@ static int svm_pre_leave_smm(struct kvm_vcpu *vcpu, const char *smstate)
>  		if (kvm_vcpu_map(&svm->vcpu, gpa_to_gfn(vmcb_gpa), &map) == -EINVAL)
>  			return 1;
>  
> -		load_nested_vmcb(svm, map.hva, vmcb);
> +		load_nested_vmcb(svm, map.hva, vmcb_gpa);
>  		ret = enter_svm_guest_mode(svm);
>  

Wrong patch?

Paolo

