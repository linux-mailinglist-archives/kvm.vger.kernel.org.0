Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6338470FDF
	for <lists+kvm@lfdr.de>; Sat, 11 Dec 2021 02:31:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345560AbhLKBf0 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Dec 2021 20:35:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbhLKBf0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Dec 2021 20:35:26 -0500
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C28AC061714;
        Fri, 10 Dec 2021 17:31:49 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id x15so35925906edv.1;
        Fri, 10 Dec 2021 17:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6CwkmUHS8TUHgTHQZNO355pdijNlHV5S9aFWvQgQHZc=;
        b=OiDVhdsbVRCuDETU8Jt6+FuOiQjFOC+k7wpNLaCz4sJSWtd8cNMPW/OSqx5JHMZywf
         66nhFTgu9cJj9d/tuqVTfQot94a+kAP7cAfqToBiDEzL+LowR9H2VgVKz4g/kxDWqYp0
         ROExg3sIBVD/KUWQoXq2Dn9GeBlyz6iaN0zHr+zhKDz/Qag6ApPyBnvUoO3/j75AUBOs
         GoKG3xvSD1+1PH5uSPxHaZ2ANT5Aqom+R4IDgB7vf/HeVhjArUxZDaM0wfukMgvO9yWp
         52ltPnwjEc6clVIubgkJSCxRRyoaZfiYHn0PGAk6brMuX0ORFrHd05qkAQjrGY2P5gjk
         L8hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:message-id:date:mime-version:user-agent
         :subject:content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=6CwkmUHS8TUHgTHQZNO355pdijNlHV5S9aFWvQgQHZc=;
        b=FbOrDKxmVbmBJW2u9Qi20l1v+mns7eTp4QeuZDI4Iavtrwb2i5LDDqDKOM7PQERmNI
         BKPsybWzFkYmAdonYhaRuCTeLOyekVhM2TqfiNtmrCZ/5DxRqjyiIJ3mY5xKmkG9laG4
         CSSQ2jWaPzvQ9VEfGbzzb8btxb61GvRXX22MzxONffbTBXMS6/ciO5Rt8NGUgvfDtGd+
         jbl3z8+3sjEMZwrIEC3h32zauTsq6tW9HKZ77crz54W7gBtktSnj8A2gwWHWZIb3mOBC
         vC4TKHj/Y+T5S+H1BEfr42E3ojnqC0DfIA6mGTfPPuh6Z507yNG3hyE5+NpaY0IqEaP0
         MFlA==
X-Gm-Message-State: AOAM530Obq2I2pQszW/GVYEHJfW3M5r2h6qlyj69gmfLcfrHZZcDZC2r
        bVGv9ckmqucOObh+oQKTSzc=
X-Google-Smtp-Source: ABdhPJxCxqvJ6GZJzbGQQpnAw4qJuopDImyNSu1ryY4/V5cbxSPQ8cU/s1spdusvRQVvjOCkLKpASw==
X-Received: by 2002:a05:6402:26cb:: with SMTP id x11mr43166963edd.149.1639186308429;
        Fri, 10 Dec 2021 17:31:48 -0800 (PST)
Received: from ?IPV6:2001:b07:6468:f312:48f9:bea:a04c:3dfe? ([2001:b07:6468:f312:48f9:bea:a04c:3dfe])
        by smtp.googlemail.com with ESMTPSA id cy26sm2245602edb.7.2021.12.10.17.31.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Dec 2021 17:31:47 -0800 (PST)
Sender: Paolo Bonzini <paolo.bonzini@gmail.com>
Message-ID: <87c26050-9242-e6fb-3fce-b6bde815f76a@redhat.com>
Date:   Sat, 11 Dec 2021 02:31:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH 15/19] kvm: x86: Save and restore guest XFD_ERR properly
Content-Language: en-US
To:     Thomas Gleixner <tglx@linutronix.de>,
        Yang Zhong <yang.zhong@intel.com>, x86@kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com
Cc:     seanjc@google.com, jun.nakajima@intel.com, kevin.tian@intel.com,
        jing2.liu@linux.intel.com, jing2.liu@intel.com
References: <20211208000359.2853257-1-yang.zhong@intel.com>
 <20211208000359.2853257-16-yang.zhong@intel.com> <87pmq4vw54.ffs@tglx>
From:   Paolo Bonzini <pbonzini@redhat.com>
In-Reply-To: <87pmq4vw54.ffs@tglx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On 12/11/21 01:10, Thomas Gleixner wrote:
>      2) When the guest triggers #NM is takes an VMEXIT and the host
>         does:
> 
>                  rdmsrl(MSR_XFD_ERR, vcpu->arch.guest_fpu.xfd_err);
> 
>         injects the #NM and goes on.
> 
>      3) When the guest writes to MSR_XFD_ERR it takes an VMEXIT and
>         the host does:
> 
>             vcpu->arch.guest_fpu.xfd_err = msrval;
>             wrmsrl(MSR_XFD_ERR, msrval);

No wrmsrl here I think, the host value is 0 and should stay so.  Instead 
the wrmsrl will happen the next time the VCPU loop is entred.

Paolo
