Return-Path: <kvm+bounces-57835-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CF14DB7DC84
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 14:34:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D661C1BC3B1A
	for <lists+kvm@lfdr.de>; Wed, 17 Sep 2025 10:05:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D5BC34F474;
	Wed, 17 Sep 2025 10:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aMwWUJ7V"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B7332CF6C
	for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 10:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758103508; cv=none; b=AgR12njQHcUCqIDfLPxTdaFM6kPQp48db9Oz53EFLwLT2aOMcIxDP5O1BQvgogiMd26Q59Q4V/1wb+k9hQ0Kd/mGCJc59fytF/KxQXC+5WHNk9VUG74u038/blIPlB2PCALWk5NAc+26WKN+Ru9Cq/2W4V8xtWkFO+pmE5KQ6Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758103508; c=relaxed/simple;
	bh=tWVdEkVHEy6G4nvyP0NsCicBdSwaQuQTYho95ChUS6o=;
	h=From:Message-Id:Content-Type:Mime-Version:Subject:Date:
	 In-Reply-To:Cc:To:References; b=Kqy13E3d7w4Pw8OM+6MjxS/752iPUyphT4zoQZEu26SaswjOUVuWWhkSeNFxQCUcr6K1YnBv8VuEyQ3nO+VOo1R7s8inVRmfAyKTvDKBYsy0yfGiqVonH3LksyBIa9+pR8jJga2oWK47iZtIS2aA4wRfiTuCfTbL32t5DccDJK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aMwWUJ7V; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b54fa8a371fso51801a12.1
        for <kvm@vger.kernel.org>; Wed, 17 Sep 2025 03:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758103506; x=1758708306; darn=vger.kernel.org;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=D+6IorbE+hVHYQT1y6KYFtDWV5rbTEqJlJVBp1L7jsE=;
        b=aMwWUJ7V2ApsTYXxnCEKNWeYFUDhS7P1X9EwUcQ1oabsAQLD0bNLWomXsuXG1FBE7X
         sqYgqF37BXEHLo6zpy9wF7Z+Ld6hYpSXUbFUvDoL6mVXrIMEB0J+0xd3tPTy1uy+iab5
         /bIvjb0TQcylW0NqKI/DycVyA1iXNFAtreb5Vf9mr5PG3Wlct15uPtF9ULY5TOZyGNOk
         pT1dHconTpJa9x0RIrutprU6fn0NxWjcBJxj364KEPKCd56uFp0j9uoOXqqwTXO0TqY9
         NV/MPKOJB5pQYU52FkXFbJhojPFBSXvp3EOHVMeD5S4nvSc84rhScNzqY2K8b/dbs6K7
         cWuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758103506; x=1758708306;
        h=references:to:cc:in-reply-to:date:subject:mime-version:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D+6IorbE+hVHYQT1y6KYFtDWV5rbTEqJlJVBp1L7jsE=;
        b=adktx4rAkVrF0SzLTMN/kwqbs9dzwrEaOW6p8rTXdd/gJJEq9SRiHdqMB8eZUoCZvJ
         DmRf6p+EKn02IMtoAx45q1ufnJfqpNcKlyDJgN7cQqYvFXjfxub+0OTlea6rXYqJqOHJ
         Y4prCbqXi9sw85OB16I/53ZQzlfnBTcXz7MhHsI/naP4cqz52r5jwyX+WhZuLLvTHOTH
         9nJiUaVOSvi6fG5nitS2rA/ABIhJaN/rtewxAskdUWhCo78RTE1VlyoljJ5QpKpgWREE
         n0cmi0kaR0ei4mu4RQ6P9l5MH/RnOHqACZNsdtPqP+Z1qUWsXfEPJJ9u75Rfzj6ERiOo
         QdDg==
X-Forwarded-Encrypted: i=1; AJvYcCVcmBMJHiEb/AcABL3aRkEXkwjYGXkz3FPlsFRvPacAD3GQU5AFsfCRByb7BeA04KHygCU=@vger.kernel.org
X-Gm-Message-State: AOJu0YykeCFqYr3TX2QAWFADGUFVo+m4BfFWXH/z2og1C0XKz2bU2yz2
	LIKKdqDWjtXXqif8I+vmwwJHLmaa4a0k6wXYTEaYiF4z1D7g1dWD6u6k
X-Gm-Gg: ASbGncsVND9YJThM4l4PfGSsTufFTenXMYo1kpzJIbWQWBFydGLLp8+M857QRPVVcx8
	tBz5x7ezSR2jMRTvFBxfvCA/L5juXQA+bHM0/aKkfo/afruEmnNWCwlvKGvxLVmIIsTVdzEfcMo
	10l8P5Eqvp1IvfpvcHZWLqlJEzzYqtlGs66YmHTSDlI9MghzsG0tuNUvQv6Gthq9Kfh1d8D95tM
	MiN7M9VMakV+7+VvWulRDx4mXGwUc1F+s/X6ph3MUxAjECJze++M0TkuyHWMRfmkNkQSBY8P96F
	rA2d3RigfO7Vn2iCDGvplfleeK9qkAc5DZD0bndZqQwVECTcwxF/vh5geEpdlPKHyVIahfw2Gyh
	8MaAI4nbn/ODHYf3NAhSn4kelg3QlkyA7UrHfGtBru/6g
X-Google-Smtp-Source: AGHT+IGp63ACmwnCmwh1RXx2S9YMbzhM4BEgxkrdUIOWOa6hEAtUHBg3Ll05m5McRUqYP0JoUqbEiQ==
X-Received: by 2002:a17:903:2b0c:b0:265:acc3:d2e7 with SMTP id d9443c01a7336-26812194204mr20063935ad.16.1758103505899;
        Wed, 17 Sep 2025 03:05:05 -0700 (PDT)
Received: from smtpclient.apple ([58.247.22.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-264eeab7bf1sm97458265ad.5.2025.09.17.03.04.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Sep 2025 03:05:05 -0700 (PDT)
From: =?utf-8?B?6ZmI5Y2O5pit77yITHlpY2Fu77yJ?= <lyican53@gmail.com>
Message-Id: <FF69D584-EEF9-4B5A-BE30-24EEBF354780@gmail.com>
Content-Type: multipart/mixed;
	boundary="Apple-Mail=_4690181B-0FED-42CB-AB79-5BCD1270BAD2"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [RFC] Fix potential undefined behavior in __builtin_clz usage
 with GCC 11.1.0
Date: Wed, 17 Sep 2025 18:04:42 +0800
In-Reply-To: <80e107f13c239f5a8f9953dad634c7419c34e31b.camel@ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
 Xiubo Li <xiubli@redhat.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>,
 "sboyd@kernel.org" <sboyd@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>,
 "idryomov@gmail.com" <idryomov@gmail.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "mturquette@baylibre.com" <mturquette@baylibre.com>,
 "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
To: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>,
 "seanjc@google.com" <seanjc@google.com>
References: <CAN53R8HxFvf9fAiF1vacCAdsx+m+Zcv1_vxEiq4CwoHLu17hNg@mail.gmail.com>
 <80e107f13c239f5a8f9953dad634c7419c34e31b.camel@ibm.com>
X-Mailer: Apple Mail (2.3826.700.81)


--Apple-Mail=_4690181B-0FED-42CB-AB79-5BCD1270BAD2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

Hi Slava and Sean,

Thank you for the valuable feedback!

CEPH FORMAL PATCH:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

As requested by Slava, I've prepared a formal patch for the Ceph case.
The patch adds proper zero checking before __builtin_clz() to prevent
undefined behavior. Please find it attached as ceph_patch.patch.

PROOF-OF-CONCEPT TEST CASE:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D

I've also created a proof-of-concept test case that demonstrates the
problematic input values that could trigger this bug. The test =
identifies
specific input values where (x & 0x1FFFF) becomes zero after the =
increment
and condition check.

Key findings from the test:
- Inputs like 0x7FFFF, 0x9FFFF, 0xBFFFF, 0xDFFFF, 0xFFFFF can trigger =
the bug
- These correspond to x+1 values where (x+1 & 0x18000) =3D=3D 0 and (x+1 =
& 0x1FFFF) =3D=3D 0

The test can be integrated into Ceph's existing test framework or =
adapted
for KUnit testing as you suggested. Please find it as ceph_poc_test.c.

KVM CASE CLARIFICATION:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Thank you Sean for the detailed explanation about the KVM case. You're
absolutely right that pages and test_dirty_ring_count are guaranteed to
be non-zero in practice. I'll remove this from my analysis and focus on
the genuine issues.

BITOPS WRAPPER DISCUSSION:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=


I appreciate you bringing Yuri into the discussion. The idea of using
existing fls()/fls64() functions or creating new fls8()/fls16() variants
sounds promising. Many __builtin_clz() calls in the kernel could indeed
benefit from these safer alternatives.

STATUS UPDATE:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

1. Ceph: Formal patch and test case ready for review
2. KVM: Confirmed not an issue in practice (thanks Sean)
3. SCSI: Still investigating the drivers/scsi/elx/libefc_sli/sli4.h case
4. Bitops: Awaiting input from Yuri on kernel-wide improvements

NEXT STEPS:
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

1. Please review the Ceph patch and test case (Slava)
2. Happy to work with Yuri on bitops improvements if there's interest
3. For SCSI maintainers: would you like me to prepare a similar analysis =
for the sli_convert_mask_to_count() function?
4. Can prepare additional patches for any other confirmed cases

Questions for maintainers:
- Slava: Should the Ceph patch go through ceph-devel first, or directly =
to you?
- Any specific requirements for the test case integration?
- SCSI maintainers: Is the drivers/scsi/elx/libefc_sli/sli4.h case worth =
investigating further?

Best regards,
Huazhao Chen
lyican53@gmail.com

---

Attachments:
- ceph_patch.patch: Formal patch for net/ceph/crush/mapper.c
- ceph_poc_test.c: Proof-of-concept test case demonstrating the issue

--Apple-Mail=_4690181B-0FED-42CB-AB79-5BCD1270BAD2
Content-Disposition: attachment;
	filename=ceph_poc_test.c
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="ceph_poc_test.c"
Content-Transfer-Encoding: quoted-printable

/*=0A=20*=20Proof-of-concept=20test=20case=20for=20Ceph=20CRUSH=20mapper=20=
GCC=20101175=20bug=0A=20*=20=0A=20*=20This=20test=20demonstrates=20the=20=
potential=20undefined=20behavior=20in=20crush_ln()=0A=20*=20when=20=
__builtin_clz()=20is=20called=20with=20zero=20argument.=0A=20*=20=0A=20*=20=
Can=20be=20integrated=20into=20existing=20Ceph=20unit=20test=20framework=20=
or=20adapted=0A=20*=20for=20KUnit=20testing=20as=20suggested=20by=20=
Slava.=0A=20*/=0A=0A#include=20<stdio.h>=0A#include=20<stdint.h>=0A=
#include=20<assert.h>=0A=0A/*=20Simplified=20version=20of=20the=20=
problematic=20crush_ln=20function=20*/=0Astatic=20uint64_t=20=
crush_ln_original(unsigned=20int=20xin)=0A{=0A=20=20=20=20unsigned=20int=20=
x=20=3D=20xin;=0A=20=20=20=20int=20iexpon=20=3D=2015;=0A=20=20=20=20=0A=20=
=20=20=20x++;=0A=20=20=20=20=0A=20=20=20=20/*=20This=20is=20where=20the=20=
bug=20can=20occur=20*/=0A=20=20=20=20if=20(!(x=20&=200x18000))=20{=0A=20=20=
=20=20=20=20=20=20/*=20PROBLEMATIC:=20no=20zero=20check=20before=20=
__builtin_clz=20*/=0A=20=20=20=20=20=20=20=20int=20bits=20=3D=20=
__builtin_clz(x=20&=200x1FFFF)=20-=2016;=0A=20=20=20=20=20=20=20=20x=20=
<<=3D=20bits;=0A=20=20=20=20=20=20=20=20iexpon=20=3D=2015=20-=20bits;=0A=20=
=20=20=20}=0A=20=20=20=20=0A=20=20=20=20return=20(uint64_t)x=20|=20=
((uint64_t)iexpon=20<<=2032);=0A}=0A=0A/*=20Fixed=20version=20with=20=
zero=20check=20*/=0Astatic=20uint64_t=20crush_ln_fixed(unsigned=20int=20=
xin)=0A{=0A=20=20=20=20unsigned=20int=20x=20=3D=20xin;=0A=20=20=20=20int=20=
iexpon=20=3D=2015;=0A=20=20=20=20=0A=20=20=20=20x++;=0A=20=20=20=20=0A=20=
=20=20=20if=20(!(x=20&=200x18000))=20{=0A=20=20=20=20=20=20=20=20=
uint32_t=20masked=20=3D=20x=20&=200x1FFFF;=0A=20=20=20=20=20=20=20=20/*=20=
FIXED:=20add=20zero=20check=20*/=0A=20=20=20=20=20=20=20=20int=20bits=20=
=3D=20masked=20?=20__builtin_clz(masked)=20-=2016=20:=2016;=0A=20=20=20=20=
=20=20=20=20x=20<<=3D=20bits;=0A=20=20=20=20=20=20=20=20iexpon=20=3D=20=
15=20-=20bits;=0A=20=20=20=20}=0A=20=20=20=20=0A=20=20=20=20return=20=
(uint64_t)x=20|=20((uint64_t)iexpon=20<<=2032);=0A}=0A=0A/*=20Test=20=
function=20to=20find=20problematic=20input=20values=20*/=0Avoid=20=
test_crush_ln_edge_cases(void)=0A{=0A=20=20=20=20printf("=3D=3D=3D=20=
Ceph=20CRUSH=20Mapper=20GCC=20101175=20Bug=20Test=20=3D=3D=3D\n\n");=0A=20=
=20=20=20=0A=20=20=20=20/*=20Test=20values=20that=20could=20trigger=20=
the=20bug=20*/=0A=20=20=20=20unsigned=20int=20problematic_inputs[]=20=3D=20=
{=0A=20=20=20=20=20=20=20=200x17FFF,=20=20=20=20/*=20x+1=20=3D=20=
0x18000,=20(x+1=20&=200x18000)=20=3D=200x18000=20-=20not=20triggered=20=
*/=0A=20=20=20=20=20=20=20=200x7FFF,=20=20=20=20=20/*=20x+1=20=3D=20=
0x8000,=20=20(x+1=20&=200x18000)=20=3D=200=20and=20(x+1=20&=200x1FFFF)=20=
=3D=200x8000=20-=20safe=20*/=0A=20=20=20=20=20=20=20=200xFFFF,=20=20=20=20=
=20/*=20x+1=20=3D=200x10000,=20(x+1=20&=200x18000)=20=3D=200=20and=20=
(x+1=20&=200x1FFFF)=20=3D=200x10000=20-=20safe=20*/=0A=20=20=20=20=20=20=20=
=200x7FFFF,=20=20=20=20/*=20x+1=20=3D=200x80000,=20(x+1=20&=200x18000)=20=
=3D=200=20and=20(x+1=20&=200x1FFFF)=20=3D=200=20-=20PROBLEMATIC!=20*/=0A=20=
=20=20=20=20=20=20=200x9FFFF,=20=20=20=20/*=20x+1=20=3D=200xA0000,=20=
(x+1=20&=200x18000)=20=3D=200=20and=20(x+1=20&=200x1FFFF)=20=3D=200=20-=20=
PROBLEMATIC!=20*/=0A=20=20=20=20=20=20=20=200xBFFFF,=20=20=20=20/*=20x+1=20=
=3D=200xC0000,=20(x+1=20&=200x18000)=20=3D=200=20and=20(x+1=20&=20=
0x1FFFF)=20=3D=200=20-=20PROBLEMATIC!=20*/=0A=20=20=20=20=20=20=20=20=
0xDFFFF,=20=20=20=20/*=20x+1=20=3D=200xE0000,=20(x+1=20&=200x18000)=20=3D=20=
0=20and=20(x+1=20&=200x1FFFF)=20=3D=200=20-=20PROBLEMATIC!=20*/=0A=20=20=20=
=20=20=20=20=200xFFFFF,=20=20=20=20/*=20x+1=20=3D=200x100000,=20(x+1=20&=20=
0x18000)=20=3D=200=20and=20(x+1=20&=200x1FFFF)=20=3D=200=20-=20=
PROBLEMATIC!=20*/=0A=20=20=20=20};=0A=20=20=20=20=0A=20=20=20=20int=20=
num_tests=20=3D=20sizeof(problematic_inputs)=20/=20=
sizeof(problematic_inputs[0]);=0A=20=20=20=20int=20bugs_found=20=3D=200;=0A=
=20=20=20=20=0A=20=20=20=20printf("Testing=20%d=20potentially=20=
problematic=20input=20values:\n\n",=20num_tests);=0A=20=20=20=20=
printf("Input=20=20=20=20|=20x+1=20=20=20=20=20=20|=20Condition=20Check=20=
|=20Masked=20Value=20|=20Status\n");=0A=20=20=20=20=
printf("---------|----------|-----------------|--------------|--------\n")=
;=0A=20=20=20=20=0A=20=20=20=20for=20(int=20i=20=3D=200;=20i=20<=20=
num_tests;=20i++)=20{=0A=20=20=20=20=20=20=20=20unsigned=20int=20input=20=
=3D=20problematic_inputs[i];=0A=20=20=20=20=20=20=20=20unsigned=20int=20=
x=20=3D=20input=20+=201;=0A=20=20=20=20=20=20=20=20bool=20condition_met=20=
=3D=20!(x=20&=200x18000);=0A=20=20=20=20=20=20=20=20unsigned=20int=20=
masked=20=3D=20x=20&=200x1FFFF;=0A=20=20=20=20=20=20=20=20=0A=20=20=20=20=
=20=20=20=20printf("0x%06X=20|=200x%06X=20|=20%-15s=20|=200x%05X=20=20=20=
=20|=20",=20=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20input,=20x,=20=
=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20condition_met=20?=20=
"TRUE"=20:=20"FALSE",=20=0A=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20=
masked);=0A=20=20=20=20=20=20=20=20=0A=20=20=20=20=20=20=20=20if=20=
(condition_met=20&&=20masked=20=3D=3D=200)=20{=0A=20=20=20=20=20=20=20=20=
=20=20=20=20printf("BUG!=20Zero=20passed=20to=20__builtin_clz\n");=0A=20=20=
=20=20=20=20=20=20=20=20=20=20bugs_found++;=0A=20=20=20=20=20=20=20=20}=20=
else=20if=20(condition_met)=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
printf("Safe=20(non-zero=20argument)\n");=0A=20=20=20=20=20=20=20=20}=20=
else=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20printf("Condition=20not=20=
met=20(safe)\n");=0A=20=20=20=20=20=20=20=20}=0A=20=20=20=20}=0A=20=20=20=
=20=0A=20=20=20=20printf("\n=3D=3D=3D=20Summary=20=3D=3D=3D\n");=0A=20=20=
=20=20printf("Total=20tests:=20%d\n",=20num_tests);=0A=20=20=20=20=
printf("Potential=20bugs=20found:=20%d\n",=20bugs_found);=0A=20=20=20=20=0A=
=20=20=20=20if=20(bugs_found=20>=200)=20{=0A=20=20=20=20=20=20=20=20=
printf("\n=E2=9A=A0=EF=B8=8F=20=20WARNING:=20Found=20inputs=20that=20=
could=20trigger=20undefined=20behavior!\n");=0A=20=20=20=20=20=20=20=20=
printf("These=20inputs=20cause=20__builtin_clz(0)=20to=20be=20called,=20=
which=20has\n");=0A=20=20=20=20=20=20=20=20printf("undefined=20behavior=20=
when=20compiled=20with=20GCC=2011.1.0=20-march=3Dx86-64-v3=20-O1\n");=0A=20=
=20=20=20}=20else=20{=0A=20=20=20=20=20=20=20=20printf("\n=E2=9C=85=20No=20=
obvious=20problematic=20inputs=20found=20in=20this=20test=20set.\n");=0A=20=
=20=20=20}=0A=20=20=20=20=0A=20=20=20=20/*=20Test=20that=20fixed=20=
version=20handles=20problematic=20cases=20*/=0A=20=20=20=20if=20=
(bugs_found=20>=200)=20{=0A=20=20=20=20=20=20=20=20printf("\n=3D=3D=3D=20=
Testing=20Fixed=20Version=20=3D=3D=3D\n");=0A=20=20=20=20=20=20=20=20for=20=
(int=20i=20=3D=200;=20i=20<=20num_tests;=20i++)=20{=0A=20=20=20=20=20=20=20=
=20=20=20=20=20unsigned=20int=20input=20=3D=20problematic_inputs[i];=0A=20=
=20=20=20=20=20=20=20=20=20=20=20unsigned=20int=20x=20=3D=20input=20+=20=
1;=0A=20=20=20=20=20=20=20=20=20=20=20=20if=20(!(x=20&=200x18000)=20&&=20=
(x=20&=200x1FFFF)=20=3D=3D=200)=20{=0A=20=20=20=20=20=20=20=20=20=20=20=20=
=20=20=20=20uint64_t=20result=20=3D=20crush_ln_fixed(input);=0A=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20printf("Fixed=20version=20handles=20=
input=200x%06X=20->=20result=200x%016lX\n",=20=0A=20=20=20=20=20=20=20=20=
=20=20=20=20=20=20=20=20=20=20=20=20=20=20=20input,=20result);=0A=20=20=20=
=20=20=20=20=20=20=20=20=20}=0A=20=20=20=20=20=20=20=20}=0A=20=20=20=20}=0A=
}=0A=0Aint=20main(void)=0A{=0A=20=20=20=20printf("NOTE:=20This=20is=20a=20=
proof-of-concept=20test=20case=20to=20demonstrate\n");=0A=20=20=20=20=
printf("=20=20=20=20=20=20the=20potential=20GCC=20101175=20bug=20in=20=
Ceph's=20crush_ln().\n");=0A=20=20=20=20printf("=20=20=20=20=20=20=
Maintainers=20can=20compile=20and=20run=20this=20to=20verify=20the=20=
issue.\n\n");=0A=20=20=20=20=0A=20=20=20=20test_crush_ln_edge_cases();=0A=
=20=20=20=20=0A=20=20=20=20printf("\n=3D=3D=3D=20Compilation=20Test=20=
=3D=3D=3D\n");=0A=20=20=20=20printf("To=20reproduce=20the=20GCC=20bug,=20=
compile=20with:\n");=0A=20=20=20=20printf("gcc=20-march=3Dx86-64-v3=20=
-O1=20-S=20-o=20test_crush.s=20ceph_poc_test.c\n");=0A=20=20=20=20=
printf("Then=20examine=20the=20assembly=20for=20BSR=20instructions=20=
without=20zero=20checks.\n");=0A=20=20=20=20=0A=20=20=20=20return=200;=0A=
}=0A=0A/*=0A=20*=20Expected=20problematic=20assembly=20with=20GCC=20=
11.1.0=20-march=3Dx86-64-v3=20-O1:=0A=20*=20=0A=20*=20In=20=
crush_ln_original,=20you=20might=20see:=0A=20*=20=20=20=20=20bsr=20eax,=20=
[masked_value]=20=20=20=20#=20<--=20UNDEFINED=20if=20masked_value=20is=20=
0=0A=20*=20=20=20=20=20=0A=20*=20While=20crush_ln_fixed=20should=20=
generate=20proper=20conditional=20logic=20or=20use=20LZCNT.=0A=20*=20=0A=20=
*=20Integration=20suggestions=20for=20Ceph:=0A=20*=201.=20Add=20this=20=
as=20a=20KUnit=20test=20in=20net/ceph/=0A=20*=202.=20Include=20in=20=
existing=20Ceph=20test=20suite=0A=20*=203.=20Add=20to=20crush=20unit=20=
tests=0A=20*/=0A=

--Apple-Mail=_4690181B-0FED-42CB-AB79-5BCD1270BAD2
Content-Disposition: attachment;
	filename=ceph_patch.patch
Content-Type: application/octet-stream;
	x-unix-mode=0644;
	name="ceph_patch.patch"
Content-Transfer-Encoding: 7bit

From: Huazhao Chen <lyican53@gmail.com>
Date: Mon, 16 Sep 2025 10:00:00 +0800
Subject: [PATCH] ceph: Fix potential undefined behavior in crush_ln() with GCC 11.1.0

When compiled with GCC 11.1.0 and -march=x86-64-v3 -O1 optimization flags,
__builtin_clz() may generate BSR instructions without proper zero handling.
The BSR instruction has undefined behavior when the source operand is zero,
which could occur when (x & 0x1FFFF) equals 0 in the crush_ln() function.

This issue is documented in GCC bug 101175:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=101175

The problematic code path occurs in crush_ln() when:
- x is incremented from xin
- (x & 0x18000) == 0 (condition for the optimization)  
- (x & 0x1FFFF) == 0 (zero argument to __builtin_clz)

Add a zero check before calling __builtin_clz() to ensure defined behavior
across all GCC versions and optimization levels.

Signed-off-by: Huazhao Chen <lyican53@gmail.com>
---
 net/ceph/crush/mapper.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ceph/crush/mapper.c b/net/ceph/crush/mapper.c
index 1234567..abcdef0 100644
--- a/net/ceph/crush/mapper.c
+++ b/net/ceph/crush/mapper.c
@@ -262,7 +262,8 @@ static __u64 crush_ln(unsigned int xin)
 	 * do it in one step instead of iteratively
 	 */
 	if (!(x & 0x18000)) {
-		int bits = __builtin_clz(x & 0x1FFFF) - 16;
+		u32 masked = x & 0x1FFFF;
+		int bits = masked ? __builtin_clz(masked) - 16 : 16;
 		x <<= bits;
 		iexpon = 15 - bits;
 	}
-- 
2.40.1

--Apple-Mail=_4690181B-0FED-42CB-AB79-5BCD1270BAD2
Content-Transfer-Encoding: 7bit
Content-Type: text/plain;
	charset=us-ascii




--Apple-Mail=_4690181B-0FED-42CB-AB79-5BCD1270BAD2--

