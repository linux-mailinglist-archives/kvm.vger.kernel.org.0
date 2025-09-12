Return-Path: <kvm+bounces-57393-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DDF9EB54B07
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 13:34:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8CB255881E5
	for <lists+kvm@lfdr.de>; Fri, 12 Sep 2025 11:34:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F29C93009FC;
	Fri, 12 Sep 2025 11:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MH9C2hqE"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979322957C2
	for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 11:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757676834; cv=none; b=aOiXz+NjMfeCUnP2JgGqSB8v1UOcHH+03/RvdIF/mb5t+yCIg5eb8d+C/ZxMXBxnMhcjlLUtLz+p0+tO+exLXgud6j0UXsy/sgMo8LNy+qfJ+X7176wXRtbdZIFG6gsQryZaDmaYUNv/iS7byVogch9JdBRB+P2FjsVAB2NZivA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757676834; c=relaxed/simple;
	bh=XBHAModFzS9RT7TpF2/ykWjDQcNt9+bCE4YK2ZwUuV0=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=rtwsR6nkdRNX2mu62IdTqak2j+LpHxMHsQHcY4ShtayQoKz19uxapSte1jVzX75CdT4wPLqZh/JHo61ITxLVLYNycCt0fHXC/CvYI7AQUblD9PP7bEPOAKzV4c0aF/AQZXVbKF1B5mJt38pMnxuO87Stw7eW5yvrFxjlBlvzrSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MH9C2hqE; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-32de344b423so1007840a91.3
        for <kvm@vger.kernel.org>; Fri, 12 Sep 2025 04:33:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757676832; x=1758281632; darn=vger.kernel.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Me3gQ2+XLChgmuRgGxhLuD7lEdljJYpRCmXxWniexUs=;
        b=MH9C2hqEnNTNu/TciRFE1ayLBu/2QhgDxOnC908dXHqhNJNxIYzEHsvpyJ8s6f8OL1
         lEE5eAdq2YdI5mUxtoo+VS/NuQJokgkNdAPVyXM/Wt5/YINrtvYvGQ/ozDn0j5Ky5rp6
         h61TX1v2V5hV7z7WjWYzUby6xrGAwJ3+QYFth5h2GIuJ0z+mGMoaBHbLnDZVeQ2W/1Bc
         lcPA+WkA7kMEuwrKteRAy9jAY2qq1iivUaa/KVVThTmDc2HZgApdBecuIlUgzY5bfHwW
         h8NladE/4KBqwXgFd1EjZfLfajJBkF4Sl5872VYr2+63wzlYMMCSOttQJ4ve9MRChJrC
         pPkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757676832; x=1758281632;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Me3gQ2+XLChgmuRgGxhLuD7lEdljJYpRCmXxWniexUs=;
        b=mxiM/KbL1UIrgviaXQWTmwnqk59tr98pclPGIuK1QgUTrp+VcNGAUcFqK0iFvPRDSX
         EzlOA7qtt6Uf8ZCKY053gsP2nGVCY2AiBMlYwrYG1EI4zvTXSqmvwBSSMY/btPnkfpSu
         LIfTu54QTS65xgvSyzjX4eYY/AjwPWoBvqNWvVpmfeAE2b6u8bd6aETaBUePQpMTsByQ
         vl8blGhvTyGhQkO5Hzj2UFswa6S/1OJxbuDF/cvbX2qfxqYTz9huuv2DqxFitUY9rQ+r
         fzXvNzFyIC9JxJXiaRd2aLVeP9K4zBqKlMebBjOW28qxJ16DDo98QHQMakvdx/UM1wH2
         FLhA==
X-Forwarded-Encrypted: i=1; AJvYcCUb+q14F1IGnirkygAJ1X1MAEM69QHwZXUYMFYQvpQsJQuTMuB8uSnv7MhoaRZlXseH96M=@vger.kernel.org
X-Gm-Message-State: AOJu0YwBuivgWFknqzsQmJcvCwFyGTnNf/CprfSKxkFc2+U/yBykxIaj
	6vyVz4jYu0Jhf3dVeaukEihjKGhqN0DV9qjCFU+lnlHlFYXYSWC0p+lMQ3qQVaKs
X-Gm-Gg: ASbGncsaWlbtkais3fp1PfmeqfUdIuzWaCuRaf8XBWsjw3JBs9ZwlQkVso4YpKwVlBf
	RtUZCxy4nYTE+cAvWGRTm14mbOcY4wqKrjHcWzQJ46Na7XaLYnhZM94QQ//yOg9pVZh3SjHjncK
	6d8MeJ3I9ObJGHpTvOZmSTl0+oCOOhN+dvpzkVqCbiPlXBN4zweZ1ZeIh4KgNW3on85HIHuSBni
	BskCyyLA1WB4L2WKj7Q7C511kXZSd82sC5TeAvSg2J5q4FeJ061tYKITnAMZHoUoqZwFLr0rzWj
	8S31vyGPHWgEo/5fSJOoSjINb4n11A4TRukA+mO7TDdOvqSvI2jeN6Z4yQutgZWlUJ3ia+69Tfo
	biHKG2YgjhmLxIgRn7n6HKg6c0HzBcFiSuiM+laWjw6JTmOYvgEr3+o+bWr6scH+rHhNstbDuNB
	kyUc+ECfU=
X-Google-Smtp-Source: AGHT+IG4CQOrsidgDKZqODfMcOoJgWe/C+OuZOd1ih4oVDYDwhAJqojGn09l0Bnkzu0cbpihXieC8w==
X-Received: by 2002:a17:90b:3889:b0:32d:5721:df96 with SMTP id 98e67ed59e1d1-32de4f808f5mr2582134a91.32.1757676831756;
        Fri, 12 Sep 2025 04:33:51 -0700 (PDT)
Received: from smtpclient.apple (p73a27f58.hyognt01.ap.so-net.ne.jp. [115.162.127.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-32dd7ceecfasm2203933a91.7.2025.09.12.04.33.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Sep 2025 04:33:51 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Itaru Kitayama <itaru.kitayama@gmail.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH] PMCR_EL0.N is RAZ/WI. At least a build failes in Ubuntu 22.04 LTS. Remove the set function.
Date: Fri, 12 Sep 2025 20:33:39 +0900
Message-Id: <3FEB4D87-EEAF-4A21-BCBC-291A4A7C2230@gmail.com>
References: <867by4c4v1.wl-maz@kernel.org>
Cc: Itaru Kitayama <itaru.kitayama@linux.dev>,
 Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>,
 K Poulose Suzuki <suzuki.poulose@arm.com>,
 Zenghui Yu <yuzenghui@huawei.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Shuah Khan <shuah@kernel.org>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, kvm@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, Itaru Kitayama <itaru.kitayama@fujitsu.com>
In-Reply-To: <867by4c4v1.wl-maz@kernel.org>
To: Marc Zyngier <maz@kernel.org>
X-Mailer: iPhone Mail (22G100)



> On Sep 12, 2025, at 20:01, Marc Zyngier <maz@kernel.org> wrote:
>=20
> =EF=BB=BFOn Fri, 12 Sep 2025 09:27:40 +0100,
> Itaru Kitayama <itaru.kitayama@linux.dev> wrote:
>>=20
>> Signed-off-by: Itaru Kitayama <itaru.kitayama@fujitsu.com>
>=20
> This isn't an acceptable commit message.
>=20
>> ---
>> Seen a build failure with old Ubuntu 22.04 LTS, while the latest release
>> has no build issue, a write to the bit fields is RAZ/WI, remove the
>> function.
>> ---
>> tools/testing/selftests/kvm/arm64/vpmu_counter_access.c | 6 ------
>> 1 file changed, 6 deletions(-)
>>=20
>> diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/to=
ols/testing/selftests/kvm/arm64/vpmu_counter_access.c
>> index f16b3b27e32ed7ca57481f27d689d47783aa0345..56214a4430be90b3e1d840f27=
19b22dd44f0b49b 100644
>> --- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
>> +++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
>> @@ -45,11 +45,6 @@ static uint64_t get_pmcr_n(uint64_t pmcr)
>>    return FIELD_GET(ARMV8_PMU_PMCR_N, pmcr);
>> }
>>=20
>> -static void set_pmcr_n(uint64_t *pmcr, uint64_t pmcr_n)
>> -{
>> -    u64p_replace_bits((__u64 *) pmcr, pmcr_n, ARMV8_PMU_PMCR_N);
>> -}
>> -
>> static uint64_t get_counters_mask(uint64_t n)
>> {
>>    uint64_t mask =3D BIT(ARMV8_PMU_CYCLE_IDX);
>> @@ -490,7 +485,6 @@ static void test_create_vpmu_vm_with_pmcr_n(uint64_t p=
mcr_n, bool expect_fail)
>>     * Setting a larger value of PMCR.N should not modify the field, and
>>     * return a success.
>>     */
>> -    set_pmcr_n(&pmcr, pmcr_n);
>>    vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0), pmcr);
>>    pmcr =3D vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0));
>>=20
>>=20
>=20
> So what are you fixing here? A build failure? A semantic defect?
> Something else? What makes this a valid change?
>=20
> Frankly, I have no idea.
>=20
> But KVM definitely allows PMCR_EL0.N to be written from userspace, and
> that's not going to change.
>=20

Then I=E2=80=99ll drop this patch.

Thanks,
Itaru.

>    M.
>=20
> --
> Without deviation from the norm, progress is not possible.

