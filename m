Return-Path: <kvm+bounces-63229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id EAB29C5E3C9
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 17:30:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 66CB3504E74
	for <lists+kvm@lfdr.de>; Fri, 14 Nov 2025 15:59:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9030C329398;
	Fri, 14 Nov 2025 15:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b="wtjxPreH"
X-Original-To: kvm@vger.kernel.org
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630151D63F5
	for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 15:51:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763135497; cv=none; b=ijbyNJkSfijhudbmbO/c7it1zdElB+MQG4J95l2oRxIIEZotBEnUCaAIdC+VtTALZ2Wx6VzrJ6poPgtxAqN+YZmqhMovwRxgN3ES+FCzJumxOIhWsMDvdJDImV23YnUCsshMa4MbP8uMZ0FHzCRl54u0DylVzjbY0NeoodJg7pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763135497; c=relaxed/simple;
	bh=p5dnCCjjECh8GBXMnFy74I0DVs1UvlTE7U+P31+Nl5A=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=ieCGWb4RsLfzKZIGTTNqevmo0PKGRhbQwL+TFeDbyevBYTWO9EHZKixuT1Ai/KH5YaxnZTl9nlLu81204t6GwbOxldz7CY6nqzotxIdvt3rRAWL64+JAIV65B8l5+MO4YjdF8QSdC/u+7iD9dGRPrJQf7Q0+46+U/qf/BZRYXIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net; spf=pass smtp.mailfrom=opensrcsec.com; dkim=pass (2048-bit key) header.d=grsecurity.net header.i=@grsecurity.net header.b=wtjxPreH; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=grsecurity.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=opensrcsec.com
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4edaf8773c4so21324301cf.1
        for <kvm@vger.kernel.org>; Fri, 14 Nov 2025 07:51:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=grsecurity.net; s=grsec; t=1763135494; x=1763740294; darn=vger.kernel.org;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=X7WvWAB8ck8zCLadmHY8xXBIsmAPAqUJdUZ+5tyKNik=;
        b=wtjxPreHKttbr0Z7JC0tehhVWRVBX99huUyjT8LqinCemeEGP/Rmf7vPpxaMO23b6R
         La3oLo4+FO1BAjUyheBkpl9R2UXhLfzTX90/1GlQ8SO64M0BoYoT155prhAg4gZNRBI1
         Lo9nT45s3Ja1aP0t6qG/+jOX//NpIJxsbsi4E85MAzieXNo+VHcDazZtl4lKalE+uEHG
         Q/q4d4FleZJx1RX3CkahgpJCAvs1Sta1cRZlY+SlY5AzZiqqzuf40JNoUDlb+PSnm6aR
         uBNUZ6NC02MLhzveqioExKH+8YYw1QGFmQI1C0yCqYZ0dwa5fwS0VWUwMoOI++rtSFal
         90RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763135494; x=1763740294;
        h=in-reply-to:autocrypt:from:content-language:references:cc:to
         :subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X7WvWAB8ck8zCLadmHY8xXBIsmAPAqUJdUZ+5tyKNik=;
        b=kqZP2g4NPzghZS3QjDd3vpO27SqEIuz18mAj5dRp1ZUYbjV6NXA0n5v6qCrA5FQHWp
         5XV9L+/HIZ/ZtQuIEXKrfUSBupB4YHkRSl/uMw22cOXEmyv9Hls+xdIlJN90UXDQacV2
         tRQyD0ys7gL17VozoagEjdpoVU7ksO/Ll/uWdsFTZJA056Iv0iOEVYILUwU7hCYyclRX
         clJcyHkmiKE+HtLehRaOH2vse6xcK0tjHb2IFGDiPxh3aXLtATTdPXMwMqIoN2OHymru
         JlAfs54iiy9FfHfkF5BrxKYrszB6uPm9U85SyrftzsZP5gYH6wDg4tZmh4kfKxZHLqYp
         AROw==
X-Gm-Message-State: AOJu0YwvSFt/mItTbjHkgrzSntbndDtMZtMZyKwFvTCy3zaypRcxeFEr
	XEzk49q3ewxSHBXeeFOcApfDWAX5YRoFc/00KRWf6eVUayqz0Vv8Qm/xWAVFqPwThgY=
X-Gm-Gg: ASbGncsDoMvz+PQBk20K1AhF6Qa/DPWCvSa3z361epW0gHeBI94EnCZ7ijc/aP2vkdo
	IRI+opFXS0sHXswLNh+K8HWSd0XiujSFxH13x2x0BWW81OrGqwahtT65/e7XFg8U5zNT3okbGR2
	iaKqMqwcPsYD/OLlqkw+RxMRgQAR8E4JHD14AcZVCkYuTRbDeNWenAEmJsPLCCzcvy3RvdmjMjX
	v2OfifAG7debLqadCLi/+ntjaF13KcIqu2EYizA32ux7aTjcj3zZ1Ubx2IspRiHNaTCg3DwyL5a
	l7WI7vxSWT8yQagGdaSXVdazeeqo58uP+TJjAe5VRjTdYGlbe8+o0MpN/EKTCMQbt4v/htViTaB
	XHUCMf9eWuHIl6DDmCF1PqzbRmjhaZ9ZUwCO0Qfq+xm7m2UKhAcDsJuRGLnqIje9wCvGSFhVCdj
	6G/TsB99e56Eap4WgRAqivzlMyb1uLkX9BAa5uUuxnasuJFuaKceYQ/bo8sG8btqyQ/duv9S1Mf
	CFE++FHy5BMUnyLybM1LAi1HnLzR3+PJfjoEQGRjHm3Tg==
X-Google-Smtp-Source: AGHT+IGkYYUfSDZIx5uUajluyOFZCpeh3pfJucDvbqVeiiigBYOMnsM9HenmXOYQAESVyM/A2lSgYw==
X-Received: by 2002:a05:622a:551:b0:4ed:4548:ac65 with SMTP id d75a77b69052e-4edf20f19cdmr48498401cf.42.1763135494118;
        Fri, 14 Nov 2025 07:51:34 -0800 (PST)
Received: from ?IPV6:2003:fa:af29:b100:e8b2:7dbf:b11:65fc? (p200300faaf29b100e8b27dbf0b1165fc.dip0.t-ipconnect.de. [2003:fa:af29:b100:e8b2:7dbf:b11:65fc])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ede881acf8sm30138601cf.29.2025.11.14.07.51.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Nov 2025 07:51:33 -0800 (PST)
Content-Type: multipart/mixed; boundary="------------htVN1Ve8dwswx0VJXy0gUugb"
Message-ID: <dbe12f67-79d0-4d92-b510-56f32401e330@grsecurity.net>
Date: Fri, 14 Nov 2025 16:51:30 +0100
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 01/17] x86/run_in_user: Add an "end
 branch" marker on the user_mode destination
To: Sean Christopherson <seanjc@google.com>
Cc: kvm@vger.kernel.org, Chao Gao <chao.gao@intel.com>,
 Paolo Bonzini <pbonzini@redhat.com>
References: <20251114001258.1717007-1-seanjc@google.com>
 <20251114001258.1717007-2-seanjc@google.com>
Content-Language: en-US, de-DE
From: Mathias Krause <minipli@grsecurity.net>
Autocrypt: addr=minipli@grsecurity.net; keydata=
 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
 RzDVkdgPJkL/NFTKZHo5foFXNi89kA==
In-Reply-To: <20251114001258.1717007-2-seanjc@google.com>

This is a multi-part message in MIME format.
--------------htVN1Ve8dwswx0VJXy0gUugb
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 14.11.25 01:12, Sean Christopherson wrote:
> Add an endbr64 at the user_mode "entry point" so that run_in_user() can be
> used when CET's Indirect Branch Tracking is enabled.

I don't think that's needed, as 'user_mode' is branched to via IRETQ and
that isn't covered by IBT -- nor is any other RET instruction.

> 
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  lib/x86/usermode.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/lib/x86/usermode.c b/lib/x86/usermode.c
> index c3ec0ad7..f4ba0af4 100644
> --- a/lib/x86/usermode.c
> +++ b/lib/x86/usermode.c
> @@ -68,6 +68,9 @@ uint64_t run_in_user(usermode_func func, unsigned int fault_vector,
>  			"iretq\n"
>  
>  			"user_mode:\n\t"
> +#ifdef __x86_64__
> +			"endbr64\n\t"
> +#endif

The thing is, this ENDBR64 is actually masking a missing cleanup step in
the IBT tests. The first failing IBT test will make the CET_U IBT
tracker state get stuck in the WAIT_FOR_ENDBRANCH state. This means,
every time we return to userland (and thereby implicitly switching to
the CET_U state again), it wants to see an ENDBR64 first or it will
directly trigger a #CP(3) again. This ENDBR64 will please that demand
and make it transition to IDLE and allow executing the test. However,
it's really the old test that should have fixed the tracker state and
not a blanket ENDBR64 when entering usermode.

Attached is a patch on top of [1] that does that but is, admitted, a
little hacky and evolved. However, it shows that above ENDBR64 is, in
fact, not needed.

Thanks,
Mathias

[1]
https://lore.kernel.org/kvm/fc886a22-49f3-4627-8ba6-933099e7640d@grsecurity.net/

>  			/* Back up volatile registers before invoking func */
>  			"push %%rcx\n\t"
>  			"push %%rdx\n\t"

--------------htVN1Ve8dwswx0VJXy0gUugb
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-x86-cet-Reset-IBT-tracker-state-on-CP-violations.patch"
Content-Disposition: attachment;
 filename*0="0001-x86-cet-Reset-IBT-tracker-state-on-CP-violations.patch"
Content-Transfer-Encoding: base64

RnJvbSA5MmYyYTgwMDBiMmM2OTU0ODI1YmRlNDUxZjMxMWViNTEzY2VmMGU4IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBNYXRoaWFzIEtyYXVzZSA8bWluaXBsaUBncnNlY3Vy
aXR5Lm5ldD4KRGF0ZTogRnJpLCAxNCBOb3YgMjAyNSAxNjo0NTo1NCArMDEwMApTdWJqZWN0
OiBba3ZtLXVuaXQtdGVzdHMgUEFUQ0hdIHg4NjogY2V0OiBSZXNldCBJQlQgdHJhY2tlciBz
dGF0ZSBvbiAjQ1AKIHZpb2xhdGlvbnMKClJlc2V0IHRoZSBJQlQgdHJhY2tlciBzdGF0ZSBi
YWNrIHRvIElETEUgb24gI0NQIHZpb2xhdGlvbnMgdG8gbm90CmluZmx1ZW5jZSBmb2xsb3ct
dXAgdGVzdHMgd2l0aCBhIHBvaXNvbmVkIHN0YXJ0aW5nIHN0YXRlLgoKU2lnbmVkLW9mZi1i
eTogTWF0aGlhcyBLcmF1c2UgPG1pbmlwbGlAZ3JzZWN1cml0eS5uZXQ+Ci0tLQogbGliL3g4
Ni91c2VybW9kZS5oIHwgMTIgKysrKysrKysrKy0tCiBsaWIveDg2L3VzZXJtb2RlLmMgfCAx
MyArKysrKysrKy0tLS0tCiB4ODYvY2V0LmMgICAgICAgICAgfCAyNSArKysrKysrKysrKysr
KysrKysrKysrLS0tCiAzIGZpbGVzIGNoYW5nZWQsIDQwIGluc2VydGlvbnMoKyksIDEwIGRl
bGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2xpYi94ODYvdXNlcm1vZGUuaCBiL2xpYi94ODYv
dXNlcm1vZGUuaAppbmRleCAwNGUzNThlMmEzYTMuLjVkNDJmNDdlYmJjNSAxMDA2NDQKLS0t
IGEvbGliL3g4Ni91c2VybW9kZS5oCisrKyBiL2xpYi94ODYvdXNlcm1vZGUuaApAQCAtMjAs
MTEgKzIwLDE5IEBAIHR5cGVkZWYgdWludDY0X3QgKCp1c2VybW9kZV9mdW5jKSh2b2lkKTsK
ICAqIFN1cHBvcnRzIHJ1bm5pbmcgZnVuY3Rpb25zIHdpdGggdXAgdG8gNCBhcmd1bWVudHMu
CiAgKiBmYXVsdF92ZWN0b3I6IGV4Y2VwdGlvbiB2ZWN0b3IgdGhhdCBtaWdodCBnZXQgdGhy
b3duIGR1cmluZyB0aGUgZnVuY3Rpb24uCiAgKiByYWlzZWRfdmVjdG9yOiBvdXRwdXRzIHRy
dWUgaWYgZXhjZXB0aW9uIG9jY3VycmVkLgorICogZXhfZXh0cmE6IGFkZGl0aW9uYWwgaGFu
ZGxlciB0byBjYWxsIHdoZW4gaGFuZGxpbmcgdHJhcHMgcmVsYXRlZCB0byBmYXVsdF92ZWN0
b3IKICAqCiAgKiByZXR1cm5zOiByZXR1cm4gdmFsdWUgcmV0dXJuZWQgYnkgZnVuY3Rpb24s
IG9yIDAgaWYgYW4gZXhjZXB0aW9uIG9jY3VycmVkLgogICovCit1aW50NjRfdCBydW5faW5f
dXNlcl9leCh1c2VybW9kZV9mdW5jIGZ1bmMsIHVuc2lnbmVkIGludCBmYXVsdF92ZWN0b3Is
CisJCXVpbnQ2NF90IGFyZzEsIHVpbnQ2NF90IGFyZzIsIHVpbnQ2NF90IGFyZzMsCisJCXVp
bnQ2NF90IGFyZzQsIGJvb2wgKnJhaXNlZF92ZWN0b3IsIGhhbmRsZXIgZXhfZXh0cmEpOwor
CitzdGF0aWMgaW5saW5lCiB1aW50NjRfdCBydW5faW5fdXNlcih1c2VybW9kZV9mdW5jIGZ1
bmMsIHVuc2lnbmVkIGludCBmYXVsdF92ZWN0b3IsCiAJCXVpbnQ2NF90IGFyZzEsIHVpbnQ2
NF90IGFyZzIsIHVpbnQ2NF90IGFyZzMsCi0JCXVpbnQ2NF90IGFyZzQsIGJvb2wgKnJhaXNl
ZF92ZWN0b3IpOwotCisJCXVpbnQ2NF90IGFyZzQsIGJvb2wgKnJhaXNlZF92ZWN0b3IpCit7
CisJcmV0dXJuIHJ1bl9pbl91c2VyX2V4KGZ1bmMsIGZhdWx0X3ZlY3RvciwgYXJnMSwgYXJn
MiwgYXJnMywgYXJnNCwgcmFpc2VkX3ZlY3RvciwgTlVMTCk7Cit9CiAjZW5kaWYKZGlmZiAt
LWdpdCBhL2xpYi94ODYvdXNlcm1vZGUuYyBiL2xpYi94ODYvdXNlcm1vZGUuYwppbmRleCA2
OWRkNjRmZmJjOTAuLjMwNWU4MjMyMDhkZiAxMDA2NDQKLS0tIGEvbGliL3g4Ni91c2VybW9k
ZS5jCisrKyBiL2xpYi94ODYvdXNlcm1vZGUuYwpAQCAtMjEsMTIgKzIxLDE3IEBAIHN0YXRp
YyB2b2lkIHJlc3RvcmVfZXhlY190b19qbXBidWYodm9pZCkKIAlsb25nam1wKGptcGJ1Ziwg
MSk7CiB9CiAKK3N0YXRpYyBoYW5kbGVyIGV4dHJhX2V4OworCiBzdGF0aWMgdm9pZCByZXN0
b3JlX2V4ZWNfdG9fam1wYnVmX2V4Y2VwdGlvbl9oYW5kbGVyKHN0cnVjdCBleF9yZWdzICpy
ZWdzKQogewogCXRoaXNfY3B1X3dyaXRlX2V4Y2VwdGlvbl92ZWN0b3IocmVncy0+dmVjdG9y
KTsKIAl0aGlzX2NwdV93cml0ZV9leGNlcHRpb25fcmZsYWdzX3JmKChyZWdzLT5yZmxhZ3Mg
Pj4gMTYpICYgMSk7CiAJdGhpc19jcHVfd3JpdGVfZXhjZXB0aW9uX2Vycm9yX2NvZGUocmVn
cy0+ZXJyb3JfY29kZSk7CiAKKwlpZiAoZXh0cmFfZXgpCisJCWV4dHJhX2V4KHJlZ3MpOwor
CiAJLyogbG9uZ2ptcCBtdXN0IGhhcHBlbiBhZnRlciBpcmV0LCBzbyBkbyBub3QgZG8gaXQg
bm93LiAgKi8KIAlyZWdzLT5yaXAgPSAodW5zaWduZWQgbG9uZykmcmVzdG9yZV9leGVjX3Rv
X2ptcGJ1ZjsKIAlyZWdzLT5jcyA9IEtFUk5FTF9DUzsKQEAgLTM1LDkgKzQwLDkgQEAgc3Rh
dGljIHZvaWQgcmVzdG9yZV9leGVjX3RvX2ptcGJ1Zl9leGNlcHRpb25faGFuZGxlcihzdHJ1
Y3QgZXhfcmVncyAqcmVncykKICNlbmRpZgogfQogCi11aW50NjRfdCBydW5faW5fdXNlcih1
c2VybW9kZV9mdW5jIGZ1bmMsIHVuc2lnbmVkIGludCBmYXVsdF92ZWN0b3IsCit1aW50NjRf
dCBydW5faW5fdXNlcl9leCh1c2VybW9kZV9mdW5jIGZ1bmMsIHVuc2lnbmVkIGludCBmYXVs
dF92ZWN0b3IsCiAJCXVpbnQ2NF90IGFyZzEsIHVpbnQ2NF90IGFyZzIsIHVpbnQ2NF90IGFy
ZzMsCi0JCXVpbnQ2NF90IGFyZzQsIGJvb2wgKnJhaXNlZF92ZWN0b3IpCisJCXVpbnQ2NF90
IGFyZzQsIGJvb2wgKnJhaXNlZF92ZWN0b3IsIGhhbmRsZXIgZXhfZXh0cmEpCiB7CiAJZXh0
ZXJuIGNoYXIgcmV0X3RvX2tlcm5lbDsKIAl2b2xhdGlsZSB1aW50NjRfdCByYXggPSAwOwpA
QCAtNDUsNiArNTAsNyBAQCB1aW50NjRfdCBydW5faW5fdXNlcih1c2VybW9kZV9mdW5jIGZ1
bmMsIHVuc2lnbmVkIGludCBmYXVsdF92ZWN0b3IsCiAJaGFuZGxlciBvbGRfZXg7CiAKIAkq
cmFpc2VkX3ZlY3RvciA9IDA7CisJZXh0cmFfZXggPSBleF9leHRyYTsKIAlzZXRfaWR0X2Vu
dHJ5KFJFVF9UT19LRVJORUxfSVJRLCAmcmV0X3RvX2tlcm5lbCwgMyk7CiAJb2xkX2V4ID0g
aGFuZGxlX2V4Y2VwdGlvbihmYXVsdF92ZWN0b3IsCiAJCQkJICByZXN0b3JlX2V4ZWNfdG9f
am1wYnVmX2V4Y2VwdGlvbl9oYW5kbGVyKTsKQEAgLTcyLDkgKzc4LDYgQEAgdWludDY0X3Qg
cnVuX2luX3VzZXIodXNlcm1vZGVfZnVuYyBmdW5jLCB1bnNpZ25lZCBpbnQgZmF1bHRfdmVj
dG9yLAogCQkJImlyZXRxXG4iCiAKIAkJCSJ1c2VyX21vZGU6XG5cdCIKLSNpZmRlZiBfX3g4
Nl82NF9fCi0JCQkiZW5kYnI2NFxuXHQiCi0jZW5kaWYKIAkJCS8qIEJhY2sgdXAgdm9sYXRp
bGUgcmVnaXN0ZXJzIGJlZm9yZSBpbnZva2luZyBmdW5jICovCiAJCQkicHVzaCAlJXJjeFxu
XHQiCiAJCQkicHVzaCAlJXJkeFxuXHQiCmRpZmYgLS1naXQgYS94ODYvY2V0LmMgYi94ODYv
Y2V0LmMKaW5kZXggODAxZDhkYTZlOTI5Li5iY2YxY2E2ZDc0MGEgMTAwNjQ0Ci0tLSBhL3g4
Ni9jZXQuYworKysgYi94ODYvY2V0LmMKQEAgLTEsNCArMSwzIEBACi0KICNpbmNsdWRlICJs
aWJjZmxhdC5oIgogI2luY2x1ZGUgIng4Ni9kZXNjLmgiCiAjaW5jbHVkZSAieDg2L3Byb2Nl
c3Nvci5oIgpAQCAtMTkyLDYgKzE5MSwxMCBAQCBzdGF0aWMgdWludDY0X3QgY2V0X2lidF9l
bXVsYXRpb24odm9pZCkKICNkZWZpbmUgQ0VUX0VOQUJMRV9TSFNUSwlCSVQoMCkKICNkZWZp
bmUgQ0VUX0VOQUJMRV9JQlQJCUJJVCgyKQogI2RlZmluZSBDRVRfRU5BQkxFX05PVFJBQ0sJ
QklUKDQpCisjZGVmaW5lIENFVF9JQlRfU1VQUFJFU1MJQklUKDEwKQorI2RlZmluZSBDRVRf
SUJUX1RSQUNLRVJfU1RBVEUJQklUKDExKQorI2RlZmluZSAgICAgSUJUX1RSQUNLRVJfSURM
RQkJCTAKKyNkZWZpbmUgICAgIElCVF9UUkFDS0VSX1dBSVRfRk9SX0VOREJSQU5DSAlCSVQo
MTEpCiAKIHN0YXRpYyB2b2lkIHRlc3Rfc2hzdGsodm9pZCkKIHsKQEAgLTI0NCw2ICsyNDcs
MjIgQEAgc3RhdGljIHZvaWQgdGVzdF9zaHN0ayh2b2lkKQogCXJlcG9ydCh2ZWN0b3IgPT0g
R1BfVkVDVE9SLCAiTVNSX0lBMzJfUEwzX1NTUCBhbGlnbm1lbnQgdGVzdC4iKTsKIH0KIAor
c3RhdGljIHZvaWQgaWJ0X3RyYWNrZXJfZml4dXAoc3RydWN0IGV4X3JlZ3MgKnJlZ3MpCit7
CisJdTY0IGNldF91ID0gcmRtc3IoTVNSX0lBMzJfVV9DRVQpOworCisJLyoKKwkgKiBTd2l0
Y2ggdGhlIElCVCB0cmFja2VyIHN0YXRlIHRvIElETEUgdG8gaGF2ZSBhIGNsZWFuIHN0YXRl
IGZvcgorCSAqIGZvbGxvd2luZyB0ZXN0cy4KKwkgKi8KKwlpZiAoKGNldF91ICYgQ0VUX0lC
VF9UUkFDS0VSX1NUQVRFKSA9PSBJQlRfVFJBQ0tFUl9XQUlUX0ZPUl9FTkRCUkFOQ0gpIHsK
KwkJY2V0X3UgJj0gfklCVF9UUkFDS0VSX1dBSVRfRk9SX0VOREJSQU5DSDsKKwkJcHJpbnRm
KCJDRVQ6IHN1cHByZXNzaW5nIElCVCBXQUlUX0ZPUl9FTkRCUkFOQ0ggc3RhdGUgYXQgUklQ
OiAlbHhcbiIsCisJCSAgICAgICByZWdzLT5yaXApOworCQl3cm1zcihNU1JfSUEzMl9VX0NF
VCwgY2V0X3UpOworCX0KK30KKwogc3RhdGljIHZvaWQgdGVzdF9pYnQodm9pZCkKIHsKIAl1
aW50NjRfdCBsOwpAQCAtMjU3LDEyICsyNzYsMTIgQEAgc3RhdGljIHZvaWQgdGVzdF9pYnQo
dm9pZCkKIAkvKiBFbmFibGUgaW5kaXJlY3QtYnJhbmNoIHRyYWNraW5nIChub3RyYWNrIGhh
bmRsaW5nIGZvciBqdW1wIHRhYmxlcykgKi8KIAl3cm1zcihNU1JfSUEzMl9VX0NFVCwgQ0VU
X0VOQUJMRV9JQlQgfCBDRVRfRU5BQkxFX05PVFJBQ0spOwogCi0JcnVuX2luX3VzZXIoY2V0
X2lidF9mdW5jLCBDUF9WRUNUT1IsIDAsIDAsIDAsIDAsICZydmMpOworCXJ1bl9pbl91c2Vy
X2V4KGNldF9pYnRfZnVuYywgQ1BfVkVDVE9SLCAwLCAwLCAwLCAwLCAmcnZjLCBpYnRfdHJh
Y2tlcl9maXh1cCk7CiAJcmVwb3J0KHJ2YyAmJiBleGNlcHRpb25fZXJyb3JfY29kZSgpID09
IENQX0VSUl9FTkRCUiwKIAkgICAgICAgIkluZGlyZWN0LWJyYW5jaCB0cmFja2luZyB0ZXN0
Iik7CiAKIAlpZiAoaXNfZmVwX2F2YWlsYWJsZSAmJgotCSAgICAoKGwgPSBydW5faW5fdXNl
cihjZXRfaWJ0X2VtdWxhdGlvbiwgQ1BfVkVDVE9SLCAwLCAwLCAwLCAwLCAmcnZjKSkgfHwg
cnZjKSkKKwkgICAgKChsID0gcnVuX2luX3VzZXJfZXgoY2V0X2lidF9lbXVsYXRpb24sIENQ
X1ZFQ1RPUiwgMCwgMCwgMCwgMCwgJnJ2YywgaWJ0X3RyYWNrZXJfZml4dXApKSB8fCBydmMp
KQogCQlyZXBvcnRfZmFpbCgiRm9yY2VkIGVtdWxhdGlvbiB3aXRoIElCVCBnZW5lcmF0ZWQg
JXMoJXUpIGF0IGxpbmUgJWx1IiwKIAkJCSAgICBleGNlcHRpb25fbW5lbW9uaWMoZXhjZXB0
aW9uX3ZlY3RvcigpKSwKIAkJCSAgICBleGNlcHRpb25fZXJyb3JfY29kZSgpLCBsKTsKLS0g
CjIuNTEuMAoK

--------------htVN1Ve8dwswx0VJXy0gUugb--

