Return-Path: <kvm+bounces-46971-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E2E28ABB80A
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 10:58:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9DD1F3A77FC
	for <lists+kvm@lfdr.de>; Mon, 19 May 2025 08:57:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D22726A0BE;
	Mon, 19 May 2025 08:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PTqzLJeo"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A045926A0D6
	for <kvm@vger.kernel.org>; Mon, 19 May 2025 08:57:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747645032; cv=none; b=AgW8dJfrkOv5B8TApXlG5iPnT87ZvjuG3pO924IJoV0HWgJlRt9usktOKhMZpUd01g+wAwSStoyp4Xpo9YgBRalw8mFyxnl5b9e7MvLuCt8vje0yAzBQ2iePb0SdiWxdle1lsIoycI93wcyTaRCTu1BfnNujsS4SttAWVLAffbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747645032; c=relaxed/simple;
	bh=TgsUBw6/6A7FvTsvKBR6l8n6JZnqtTuIQiDETXqRu6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X0aVQ0wFK8uwgnkPQNm2eTGAbzmj5oopbBkM4QcTc+bBlGnZjYPdiLPMQnOToyV3Q1AKcWJ0/0XebkAgSfTuO0wtHrvntfIwwyNekK1D6OACkHddrzXL+ojaNZxJpB8Gury9q7dNI5FaUnpTEBUa67BfDU+/TSOlRQAGxIxgQoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PTqzLJeo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1747645029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=57lbWIGpAZjDd2L3740mwnHRJL/CETq+opyWz0J1phk=;
	b=PTqzLJeo5vUrtkO71KkM4IBSXUjycyceNiFzu2/i02w8NxFgd7gGL8ykyiWsFw4aLp0dG1
	SCRDP248IoR6T3sI9WRwf6Aj9naKNtrXl+pkz0HAdKKtwJmJPlp56n5Qs9cn8sSg7dVSvj
	q4Zsed/Rd8OcIfkTC1/9W6PMV7CSvdk=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-8qOi_s-dPESYMSo4zmpp0A-1; Mon, 19 May 2025 04:57:08 -0400
X-MC-Unique: 8qOi_s-dPESYMSo4zmpp0A-1
X-Mimecast-MFC-AGG-ID: 8qOi_s-dPESYMSo4zmpp0A_1747645027
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-b0e5f28841dso2859539a12.2
        for <kvm@vger.kernel.org>; Mon, 19 May 2025 01:57:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747645027; x=1748249827;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=57lbWIGpAZjDd2L3740mwnHRJL/CETq+opyWz0J1phk=;
        b=bZNPpfSNe5zUcZjwT6EXNpXoH5O4lSdUCgxRBXiwN1blMT8RSgZ6kcEs0ycp5fZkNN
         qRvVdExT2TErZ4K4kqllwv4MVZ4ZQn7pcvOzPVlTx0hdjwfjZbfdpbiqBrB/RXlrCEVN
         T3mqYGuwOVwUm++I36+OXICRtgZHRh7FjxM5k3I3GryZ5fS5C534/0K7qwcm6/TfOUqu
         t8I7yFn8sc/dOdQq6YLsWYoelg+kc+LREVmOKDULUJK+zyOrkaFsf23W1XXPc9VAypQU
         W8So1F+TQIt9khxKjPrVnXYYeftqNZ38mnKlwyRxLRLUvPDwZg48ZsCkIqJHlagNTcbw
         8UwA==
X-Gm-Message-State: AOJu0YzJugRUMUKemLQgCllHtfAAK3sVUwhChJU++NkB0b2wFaXln3SK
	v/HkzaQVfhtytnLDSui+rGnUnODe1L5LtGoACtjDyvxqCm5/1kgGGlWmZxmuXne8FwGmMmty5mf
	S8GBv8ZdGDCbRcImbI9J1bY+tnQlVaNMDYg6zYUoahgFTYuDiFkUq8g==
X-Gm-Gg: ASbGnctzs9HayZEK7ZLrs8NXf6x2ElqpwOrqtQS/PawoXI3Ob7aTCfFo5Ni99WCLTo6
	dVaGQEeJnXxZR4mfbuM+kqjxcJ8Rnh/qpF7mTLGGccOabugE5BupLcdx3VgvO1cggpmhAMaeurp
	JGQyMgq1kcaIghAcrphBssbzIvh84BrGAKJjWX3if8kUcEw+2fMH0MJ34X/N/VLdoueECh29LXg
	5/14RXlLvaWy/Qf5sqyR+tOM0PnMa/VdcN7b6xr/HfYzL5XgWqA/qHLHaTFBDJX6XvKVBla3rbn
	wUs4rsP88yC5mnoL
X-Received: by 2002:a05:6a21:a341:b0:1f6:6539:e026 with SMTP id adf61e73a8af0-216218e668fmr19448394637.15.1747645026956;
        Mon, 19 May 2025 01:57:06 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE+BBkV0dSDFn9S/kO/xVvSG5+nt7BjgxgmMpQUjhktNCq5vzK536Q0m1eaNG4mx2NI/khDRA==
X-Received: by 2002:a05:6a21:a341:b0:1f6:6539:e026 with SMTP id adf61e73a8af0-216218e668fmr19448372637.15.1747645026548;
        Mon, 19 May 2025 01:57:06 -0700 (PDT)
Received: from [10.72.116.146] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b26eb0a89edsm5672369a12.67.2025.05.19.01.56.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 May 2025 01:57:05 -0700 (PDT)
Message-ID: <1ecedde8-8d18-43f1-a3b7-e8bcc82a61f0@redhat.com>
Date: Mon, 19 May 2025 16:56:56 +0800
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [kvm-unit-tests PATCH v3 00/16] arm/arm64: Add kvmtool to the
 runner script
To: Alexandru Elisei <alexandru.elisei@arm.com>, andrew.jones@linux.dev,
 eric.auger@redhat.com, lvivier@redhat.com, thuth@redhat.com,
 frankja@linux.ibm.com, imbrenda@linux.ibm.com, nrb@linux.ibm.com,
 david@redhat.com, pbonzini@redhat.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
 linux-s390@vger.kernel.org, will@kernel.org, julien.thierry.kdev@gmail.com,
 maz@kernel.org, oliver.upton@linux.dev, suzuki.poulose@arm.com,
 yuzenghui@huawei.com, joey.gouly@arm.com, andre.przywara@arm.com
References: <20250507151256.167769-1-alexandru.elisei@arm.com>
Content-Language: en-US
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20250507151256.167769-1-alexandru.elisei@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Alexandru,

For this series, I've tested it, everything works good.

On 5/7/25 11:12 PM, Alexandru Elisei wrote:
> v2 can be found here [1].
> 
> To goal is to allow the user to do:
> 
> $ ./configure --target=kvmtool
> $ make clean && make
> $ ./run_tests.sh
> 
> to run all the tests automatically with kvmtool.
> 
> Reasons to use kvmtool:
> 
> * kvmtool is smaller and a lot easier to hack than qemu, which means
> developers may prefer it when adding or prototyping new features to KVM.
> Being able to run all the tests reliably and automatically is very useful
> in the development process.
> 
> * kvmtool is faster to run the tests (a couple of times faster on
> my rockpro64), making for a quick turnaround. But do keep in mind that not
> all tests work on kvmtool because of missing features compared to qemu.
> 
> * kvmtool does things differently than qemu: different memory layout,
> different uart, PMU emulation is disabled by default, etc. This makes it a
> good testing vehicule for kvm-unit-tests itself.
> 
> Changes in v3
> -------------
> 
> Lots of changes following the excellent feedback I got. A bird's eye view:
> 
> * Split extra_params into qemu_params and test_args: qemu_params for qemu
> arguments and test_args for the test's main() function.
> 
> Now that I'm putting the cover letter together I'm considering that maybe
> having qemu_params, kvmtool_params and test_params (instead of test_args)
> might be a better naming scheme.
> 
> * TARGET is now exported unconditionally. Unfortunately a side effect of
> this is that checking out these series and running the tests will end up
> with an error because the scripts now expect TARGET to be defined in
> config.mak.
> 
> If it's unacceptable, I can drop this and handle everything in vmm.bash by
> converting direct accesses to vmm_opts with functions defined in vmm.bash
> (vmm_opts[$TARGET:parse_premature_failure] becomes
> vmm_parse_premature_failure(), for example).
> 
> * Introduced scripts/vmm.bash to keep the vmm stuff contained. As a
> consequence there's very little $TARGET stuff in scripts/runtime.bash (only
> for premature_failure(), and no more 'case' statements anywhere) and
> instead scripts/common.bash passes the correct arguments directly to
> runtime.bash::run().
> 
> Unfortunately, because of all the changes, I decided not to keep some of
> the Reviewed-by tags. That's not to say that the effort is not appreciated,
> on the contrary, these changes are a direct result of the review; I dropped
> the tags because I was worried they might not apply to the current content
> of the patches.
> 
> If no major changes are needed following this round of review, for the next
> iteration I'm planning to send the first two patches (extra_params renamed
> to qemu_params and the new test_args) separately, to make sure it gets the
> review it deserves from the rest of the architectures.
> 
> Still haven't managed to get EDK2 to work with kvmtool, so I've decided to
> explicitely disabled UEFI tests in the last patch ("scripts: Enable
> kvmtool") - this is new.
> 
> I would also like to point out that despite Drew's comment I kept the
> 'disabled_if' test definition because I think using 'targets', with the
> default value of 'qemu', will probably lead to most, if not all, of the new
> tests which will be added never being run or tested with kvmtool. More
> details in patch #15 ("scripts: Add 'disabled_if' test definition parameter
> for kvmtool to use").
> 
> [1] https://lore.kernel.org/kvm/20250120164316.31473-1-alexandru.elisei@arm.com/
> 
> Alexandru Elisei (16):
>    scripts: unittests.cfg: Rename 'extra_params' to 'qemu_params'
>    scripts: Add 'test_args' test definition parameter
>    configure: Export TARGET unconditionally
>    run_tests.sh: Document --probe-maxsmp argument
>    scripts: Document environment variables
>    scripts: Refuse to run the tests if not configured for qemu
>    scripts: Use an associative array for qemu argument names
>    scripts: Add 'kvmtool_params' to test definition
>    scripts: Add support for kvmtool
>    scripts: Add default arguments for kvmtool
>    scripts: Add KVMTOOL environment variable for kvmtool binary path
>    scripts: Detect kvmtool failure in premature_failure()
>    scripts: Do not probe for maximum number of VCPUs when using kvmtool
>    scripts/mkstandalone: Export $TARGET
>    scripts: Add 'disabled_if' test definition parameter for kvmtool to
>      use
>    scripts: Enable kvmtool
> 
>   README.md               |  18 ++++-
>   arm/efi/run             |   8 ++
>   arm/run                 | 161 +++++++++++++++++++++++--------------
>   arm/unittests.cfg       | 125 ++++++++++++++++++++---------
>   configure               |  37 ++++++---
>   docs/unittests.txt      |  54 +++++++++++--
>   powerpc/run             |   4 +-
>   powerpc/unittests.cfg   |  21 ++---
>   riscv/run               |   4 +-
>   riscv/unittests.cfg     |   2 +-
>   run_tests.sh            |  35 ++++++---
>   s390x/run               |   2 +-
>   s390x/unittests.cfg     |  53 +++++++------
>   scripts/arch-run.bash   | 113 ++++++++++----------------
>   scripts/common.bash     |  71 +++++++++++------
>   scripts/mkstandalone.sh |   4 +
>   scripts/runtime.bash    |  51 +++++-------
>   scripts/vmm.bash        | 170 ++++++++++++++++++++++++++++++++++++++++
>   x86/run                 |   4 +-
>   x86/unittests.cfg       | 164 +++++++++++++++++++++-----------------
>   20 files changed, 730 insertions(+), 371 deletions(-)
>   create mode 100644 scripts/vmm.bash
> 
> 
> base-commit: 08db0f5cfbca16b36f200b7bc54a78fa4941bcce

-- 
Shaoqin


