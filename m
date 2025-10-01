Return-Path: <kvm+bounces-59340-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58E8ABB15E8
	for <lists+kvm@lfdr.de>; Wed, 01 Oct 2025 19:32:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 081681639CF
	for <lists+kvm@lfdr.de>; Wed,  1 Oct 2025 17:32:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77F51257AD1;
	Wed,  1 Oct 2025 17:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rZviu7rN"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DB7C17AE1D
	for <kvm@vger.kernel.org>; Wed,  1 Oct 2025 17:32:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759339953; cv=none; b=H1QTIy1la8LpX1QqdCPGyFIrI2KOVBCsUlHaOE1Va9SniqafEEX78OT4LAzf2mTvhQdryYCSr1akc+f1739rtTrJ/nUMNo08KGcCpMHs+RMSIFlTU8hTR8C9ApEpH9spnrB9sMShPVHXYlBeqfKZLd1ubV9/2A3Xmd0UuKkkzlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759339953; c=relaxed/simple;
	bh=rHk1d9c2nYAN1GlB0Qqqi7n0BwmF7bTieJ3BBoipGQQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=msthW0JHhiAKNvwyFzMCueOiWUs4nNbwfi3PfRL2lDTV4mQH+C9uy/N0f/ILVYYdW/dK6ywjzXAARmYqSYspAgIfn5E9ILoT+Avzz/crjnHMEfGUjakqKDxnQwYOXSFKgCiHIjXlnZzYQ6eE2iebHXyzLdY4uw/lTJnKgM6v5BA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rZviu7rN; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2681645b7b6so11625ad.1
        for <kvm@vger.kernel.org>; Wed, 01 Oct 2025 10:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759339951; x=1759944751; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=o/YWYDtjG6ffJt7pjNnPORxoGZIxj6mJz/9fII2K1Ck=;
        b=rZviu7rNflHsAnnPv03L/jMoSaIqJitVwkZvP/Q67NIiR0n5AE2JvW7g/awp4j1d1v
         S1FC5V3cZujZr1SJPQMwvbqusmH2RLbBmCB87dY4Vtt/XrF1pGX5bEQo0I8NfGOyCC7v
         v2aEF8EiVBlEqVgIPzsqJO8Ck7uNd1qZCvLf0TCUy371URVQ6tOSZNKGkq2uDlkHywbT
         Srns2KZBeRpvXCYFnSQI6LvYpeHCO2w0NWZyRzwxBewfBrimQ6DU5nUfiIk2NdrSbh/b
         e7PgZS6AnAwYQIeDsV3Dnc6K+0ZpzBAKpBr0o4fGznr7sPdRFHEjAOSjVwE76+aITufo
         g34g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759339951; x=1759944751;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o/YWYDtjG6ffJt7pjNnPORxoGZIxj6mJz/9fII2K1Ck=;
        b=N+wz7/oEGvrNaOAhXXiI4NsZ3NFALhvYciBlEzaR1acsqaRhQyxBwnfGMz5tYlal7z
         QUJLiE3IdboWm3W20FtTGpuIEyAiGaboeVqjiUVjhCz8fS2+CmkktltLogxp+sKOYn5b
         OkFdP36hPZh5es2G5lcC94Afin3z8xQnBGLtl412F0wO/g66svAXfRBWViBvb2A+WzrX
         ZIvKFQk2/x08S66u6lAe8Cr7BQUAcl1VGoC8uD2WiOnWStpK2PplUc55NjOaBab1MKn1
         frKmx7YuHFUNI49JOxvgWJi/tqMf6eCpb0bNVuxWYoHkXvvEXKWo3wcRmTcNELa+Xny4
         H/7Q==
X-Gm-Message-State: AOJu0Yy1/wYcYa24lYi/Tn41xkCGU9oL1ht7IhufcHE5Cv1/ahBkTWUp
	noDGt3NhaBxwdxTPAt+J3zqe36XGoxeOvlJHC/93Zw6l4QtSDXN05h3unp08FHz/iw==
X-Gm-Gg: ASbGncuBajC1Mfdgd0NKfa3d4dMyrma30JrTUc3PX6nwmi0zoAJcodDB0hNOI7Y7d/0
	gx5xjl1Ub1dkizbuFvFitj+fNI/qVzsHrSSGlCGxvpNDdi9h+KuYRS4JO3Yj5OpBFodAOFoNZ2m
	vC8n4/ZyiuLAeH24aCpZMLxE/1lV/k8IF6IQdoMJAvVc6U0yKavCaJ84Isj+EBOU+OSyJVYrazK
	TiDYkjo0PShFpSjpCVyG73EYgeRP1kRjWH9mbiZhYWPBvR74FCdqEuYTWWwi8MlhruKTCS1Kjui
	E3Ld6LGzHGA9WOk9fM9CZzXl2nPjNqZgqoTwZT2pjlGJZT3yEzYSE5NxMg4ztErbnKHXfQjHhpv
	sauGtk0VtGXxT60pKBUMHoyyKm2LxOCd8dfxoeb7ofqcW9babbEql52bl+oeFobataQ4qCuVJZH
	yu6qzVNRmXFVMhqz6BDQ==
X-Google-Smtp-Source: AGHT+IHx7ebKepLK2+ba7wopXv1hEpDMMQTNfdMH8JIKjgqqvoILE8tuG/fflLyAGOySPePvLbMnkQ==
X-Received: by 2002:a17:903:22c2:b0:26d:a02f:b046 with SMTP id d9443c01a7336-28e8dd04808mr80535ad.11.1759339950898;
        Wed, 01 Oct 2025 10:32:30 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-339a6ff0dddsm2827615a91.18.2025.10.01.10.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 10:32:30 -0700 (PDT)
Date: Wed, 1 Oct 2025 10:32:25 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
	kvm-riscv@lists.infradead.org, seanjc@google.com,
	pbonzini@redhat.com, borntraeger@linux.ibm.com,
	frankja@linux.ibm.com, imbrenda@linux.ibm.com, anup@brainfault.org,
	atish.patra@linux.dev, zhaotianrui@loongson.cn, maobibo@loongson.cn,
	chenhuacai@kernel.org, oliver.upton@linux.dev,
	ajones@ventanamicro.com
Subject: Re: [PATCH v3 9/9] KVM: selftests: Provide README.rst for KVM
 selftests runner
Message-ID: <20251001173225.GA420255.vipinsh@google.com>
References: <20250930163635.4035866-1-vipinsh@google.com>
 <20250930163635.4035866-10-vipinsh@google.com>
 <86qzvnypsp.wl-maz@kernel.org>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <86qzvnypsp.wl-maz@kernel.org>

On 2025-10-01 09:44:22, Marc Zyngier wrote:
> On Tue, 30 Sep 2025 17:36:35 +0100,
> Vipin Sharma <vipinsh@google.com> wrote:
> > 
> > +KVM selftest runner is highly configurable test executor that allows to run
> > +tests with different configurations (not just the default), parallely, save
> 
> s/parallely/in parallel/
> 

Thanks, I will fix it.

> > +output to disk hierarchically, control what gets printed on console, provide
> > +execution status.
> > +
> > +To generate default tests use::
> > +
> > +  # make tests_install
> > +
> > +This will create ``testcases_default_gen`` directory which will have testcases
> 
> I don't think using the future tense is correct here. I'd rather see
> something written in the present tense, possibly imperative. For
> example:
> 
> "Create 'blah' directory containing 'foo' files, one per test-case.
> 

Thanks, I will fix it.

> > +in `default.test` files. Each KVM selftest will have a directory in  which
> > +`default.test` file will be created with executable path relative to KVM
> > +selftest root directory i.e. `/tools/testing/selftests/kvm`.
> 
> Shouldn't this honor the existing build output directives? If it
> actually does, then you want to call this out.
> 

To generate default test files in a specific directory one can use
"OUTPUT" in the make command

  make OUTPUT="~/test/directory/path" tests_install

This allows to generate testcases_default_gen in the given output
directory. default.test files will still have test binary path relative
kvm selftest root directory. 

$OUTPUT
└── testcases_default_gen
    ├── access_tracking_perf_test
    │   └── default.test
    ├── arch_timer
    │   └── default.test
    ├── arm64
    │   ├── aarch32_id_regs
    │   │   └── default.test
    │   ├── arch_timer_edge_cases
    │   │   └── default.test
    │   ├── debug-exceptions
    │   │   └── default.test
    │   ├── external_aborts
    │   │   └── default.test
    │   │   └── default.test
    │   └── ...
    ├── coalesced_io_test
    │   └── default.test
    ├── demand_paging_test
    │   └── default.test
    ├── ...

So, arm64/aarch32_id_regs/default.test will have 'arm64/aarch32_id_regs'

User can then supply -p/--path with the path of build output directory
to runner. 

  python3 runner -p ~/path/to/selftest/binaries -d $OUTPUT/testcases_default_gen

If -p not given then current directory is considered for test
executables.

> > For example, the
> > +`dirty_log_perf_test` will have::
> > +
> > +  # cat testcase_default_gen/dirty_log_perf_test/default.test
> > +  dirty_log_perf_test
> > +
> > +Runner will execute `dirty_log_perf_test`. Testcases files can also provide
> > +extra arguments to the test::
> > +
> > +  # cat tests/dirty_log_perf_test/2slot_5vcpu_10iter.test
> > +  dirty_log_perf_test -x 2 -v 5 -i 10
> > +
> > +In this case runner will execute the `dirty_log_perf_test` with the options.
> > +
> 
> The beginning of the text talks about "non-default' configurations,
> but you only seem to talk about the default stuff. How does one deals
> with a non-default config?
> 

In the patch 1, I created two sample tests files,
2slot_5vcpu_10iter.test and no_dirty_log_protect.test, in the directory
tools/testing/selftests/kvm/tests/dirty_log_perf_test.

Contents of those files provide non-default arguments to test, for example,
2slot_5vcpu10iter.test has the command:

  dirty_log_perf_test -x 2 -v 5  -i 10

One can run these non-default tests as (assuming current directory is
kvm selftests):

  python3 runner -d ./tests

Over the time we will add more of these non-default interesting
testcases. One can then run:

  python3 runner -d ./tests ./testcases_default_gen



