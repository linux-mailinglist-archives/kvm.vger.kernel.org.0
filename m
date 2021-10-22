Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B70B437156
	for <lists+kvm@lfdr.de>; Fri, 22 Oct 2021 07:29:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbhJVFbP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 22 Oct 2021 01:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbhJVFbO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 22 Oct 2021 01:31:14 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3A66C061764
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 22:28:57 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id n11-20020a17090a2bcb00b001a1e7a0a6a6so1139035pje.0
        for <kvm@vger.kernel.org>; Thu, 21 Oct 2021 22:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=SS9QqHqUYluZ268C4nFh5lnMMDORmPFGYje9es0NYJM=;
        b=Txs5ixS6kJGc79P674nndZt2KayYJj0FSML/E7gdXrXWZ65RnjmZDxFzCYDpr14E1D
         6AmgQ71LPAGgUqY3UTmCuykbLV+bFPebIm+dCI2oztfv/ABDChkAm5ZDiqilzhDPYwET
         RLJAZ1Vs2LZkgrltzliVmPs8HwnuSO2nVQ88gmLPccb3tq+mbqHYnZ1Y/DoQFmAozfzS
         3Zy/AoufRIWPY0a1VM4v3hQ/Kusw3bbDgKV41RQjEqAP48de14eic2aB+OxjwfJ5TLqW
         L5CyPzZusqFMeaf2nNB2UaztYAZo6NVzWlCtM9trsNRuMZahX2eptnlRxeSf3Ww6wavr
         cdPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=SS9QqHqUYluZ268C4nFh5lnMMDORmPFGYje9es0NYJM=;
        b=TRXXRh1h0TD48T8AN2Meu+8A5AvC//LtUV9ylpAnTMoKIJ/ajcN5pkmp7qMogG00d1
         BnX9/L5jtCLbQ5tXSHe1jtbN3WIeHTJTX4K7QL2VIlENqKVPRW6IT0LghqIoaf3LPBFw
         y6c0ajSg0AofZ9WmmlnJ9FHaT+wBS/o8jbjGopUMDW7eCLhkO8q98xvbbVYmfHRFMIx1
         9RnBWaCO4g8YnWd/wE6+y3iq058wjoJwxskPYk4U5qdZAwQ8G+1mBI3AI0oa+K8QgLsc
         vzJigZuWfmCecQHZvmyFsedMtCLHPpxc4UzDAjkekzOOp8hqzG9zvd3ehvIEbcY/wHxI
         r9wQ==
X-Gm-Message-State: AOAM531Chs3Hqui/vud4w14kKLG+2MrQy26p8hyswG1aRMwJOpqJKPle
        hlyGw4/kg1PhAnjPBzpfj1o=
X-Google-Smtp-Source: ABdhPJw8ivGG2iXoPdKA0GXgPuhWksQR86VfkQPHg72cUPU6NVCQ34vFfI95yXWBS4h0IjfN9YNuPQ==
X-Received: by 2002:a17:90b:3802:: with SMTP id mq2mr11785914pjb.213.1634880537256;
        Thu, 21 Oct 2021 22:28:57 -0700 (PDT)
Received: from smtpclient.apple (c-24-6-216-183.hsd1.ca.comcast.net. [24.6.216.183])
        by smtp.gmail.com with ESMTPSA id h4sm11293684pjm.14.2021.10.21.22.28.55
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 21 Oct 2021 22:28:56 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [PATCH][v2] KVM: x86: directly call wbinvd for local cpu when
 emulate wbinvd
From:   Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <4857464fb9684af8a485ce9eb790fd75@baidu.com>
Date:   Thu, 21 Oct 2021 22:28:54 -0700
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <ABB2D0B2-A280-499B-96F8-69F8FC543605@gmail.com>
References: <1634118172-32699-1-git-send-email-lirongqing@baidu.com>
 <4857464fb9684af8a485ce9eb790fd75@baidu.com>
To:     "Li,Rongqing" <lirongqing@baidu.com>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org



> On Oct 21, 2021, at 9:16 PM, Li,Rongqing <lirongqing@baidu.com> wrote:
>=20
> Ping=20
>=20
> -Li
>=20
>> -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
>> =E5=8F=91=E4=BB=B6=E4=BA=BA: Li,Rongqing <lirongqing@baidu.com>
>> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2021=E5=B9=B410=E6=9C=8813=E6=97=A5=
 17:43
>> =E6=94=B6=E4=BB=B6=E4=BA=BA: x86@kernel.org; kvm@vger.kernel.org; =
Li,Rongqing
>> <lirongqing@baidu.com>
>> =E4=B8=BB=E9=A2=98: [PATCH][v2] KVM: x86: directly call wbinvd for =
local cpu when emulate
>> wbinvd
>>=20
>> directly call wbinvd for local cpu, instead of calling atomic =
cpumask_set_cpu to
>> set local cpu, and then check if local cpu needs to run in =
on_each_cpu_mask
>>=20
>> on_each_cpu_mask is less efficient than smp_call_function_many, since =
it will
>> close preempt again and running call function by checking flag with
>> SCF_RUN_LOCAL. and here wbinvd can be called directly
>>=20
>> In fact, This change reverts commit 2eec73437487 ("KVM: x86: Avoid =
issuing
>> wbinvd twice"), since smp_call_function_many is skiping the local cpu =
(as
>> description of c2162e13d6e2f), wbinvd is not issued twice
>>=20
>> and reverts commit c2162e13d6e2f ("KVM: X86: Fix missing local pCPU =
when
>> executing wbinvd on all dirty pCPUs") too, which fixed the previous =
patch, when
>> revert previous patch, it is not needed.
>>=20
>> Signed-off-by: Li RongQing <lirongqing@baidu.com>
>> ---
>> diff v2: rewrite commit log
>>=20
>> arch/x86/kvm/x86.c |   13 ++++++-------
>> 1 files changed, 6 insertions(+), 7 deletions(-)
>>=20
>> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c index =
aabd3a2..28c4c72
>> 100644
>> --- a/arch/x86/kvm/x86.c
>> +++ b/arch/x86/kvm/x86.c
>> @@ -6991,15 +6991,14 @@ static int kvm_emulate_wbinvd_noskip(struct
>> kvm_vcpu *vcpu)
>> 		return X86EMUL_CONTINUE;
>>=20
>> 	if (static_call(kvm_x86_has_wbinvd_exit)()) {
>> -		int cpu =3D get_cpu();
>> -
>> -		cpumask_set_cpu(cpu, vcpu->arch.wbinvd_dirty_mask);
>> -		on_each_cpu_mask(vcpu->arch.wbinvd_dirty_mask,
>> +		preempt_disable();
>> +		smp_call_function_many(vcpu->arch.wbinvd_dirty_mask,
>> 				wbinvd_ipi, NULL, 1);
>> -		put_cpu();
>> +		preempt_enable();
>> 		cpumask_clear(vcpu->arch.wbinvd_dirty_mask);
>> -	} else
>> -		wbinvd();
>> +	}
>> +
>> +	wbinvd();
>> 	return X86EMUL_CONTINUE;
>> }

KVM is none of my business, but on_each_cpu_mask() should be more
efficient since it would run wbinvd() concurrently locally and
remotely (this is a relatively recent change I made). wbinvd() is
an expensive operation, and preempt_enable() is cheap, so there
should not be complicated tradeoff here.=20

The proposed change prevents running wbinvd() concurrently so
theoretically it should cause a 2x slowdown (for this specific
piece of code).

