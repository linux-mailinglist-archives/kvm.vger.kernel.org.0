Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30958B42B3
	for <lists+kvm@lfdr.de>; Mon, 16 Sep 2019 23:11:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389113AbfIPVLl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 Sep 2019 17:11:41 -0400
Received: from mail-wr1-f47.google.com ([209.85.221.47]:34184 "EHLO
        mail-wr1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388977AbfIPVLl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 Sep 2019 17:11:41 -0400
Received: by mail-wr1-f47.google.com with SMTP id a11so932001wrx.1
        for <kvm@vger.kernel.org>; Mon, 16 Sep 2019 14:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7/eixFT5wlPhK5A25/reKO1FSlliFFsCcmWzjUKnbn8=;
        b=sUlpaswMJbG/wGyojRjnULb4OTbUx3lN54yaHp3TlbbSzoTFMpWL9Q9hFKK7moYcvv
         DBLWvp3qoyovB3UBNIIuS+kTylipm00A++JFheR/nnYa19kY34LbqLjGRrzLF1KX8Hyq
         ePHFzaf2N8TuB14axKSQkYxXr4xy4hrTNZu24TaOD5x8NZeCTKHFKjiEwyKqXvsiir3I
         t4oVZ4cMhxx3dqgh5dFUhDV3F8iqiUPGBS8rLibju9g6Nc/LItjU9qlDjdzmclJtIWM8
         kXot0FPzga2HiS/Rtx3HiohX11WSmj2+SKmA9PDbttkEYkNYLKwhGRwPaZSlIySybYAO
         cfeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7/eixFT5wlPhK5A25/reKO1FSlliFFsCcmWzjUKnbn8=;
        b=SN1dBPzaqLGqkZKhVMcAkhSW+HbWYkgmwu2m6flj2yADJTvOG61qjjt30Ojecit0kD
         uJ302MLEN/vlNy6xXoOB7kOWVQh8yI+jtTyCR7eR7yZB8qrgSNz/opaReK5hD6q6KBYi
         JhVQe7bePyqfkDHQW/X3i57o+Pxf/FDdDzOoVq9M6zJH/6G3fvAKDWny7midHMIZqK/A
         5k+dUSsvU0fJaoObpMsh5uyqFtgc7aR/q9Ng3kApnlPBHoizbw0l1U4KPmAF2iadFQ7+
         kNsbSMKa6m/LMX1613qyaO9GGyBlej4NYOddxsNyIYu+i/zOPvsC5viH0rZLZeSC432q
         WG0Q==
X-Gm-Message-State: APjAAAWSi7+fUyMGm3vMMiSk/6bf6NczYO5Xh/EBR3UO7lQdWAuqrwlp
        xU2gMboKrdgHttz3JxEvUUKChO0XohOv1UmFAvJ83A==
X-Google-Smtp-Source: APXvYqz5u7Tyi55LY2kZND4FwUxMZ6+bIK81IRrrNSsNGbVqKR8qZ8vNRNlswtEypWJSz2obJLEE2jwqIT/OpvDDJ8Q=
X-Received: by 2002:adf:e9ce:: with SMTP id l14mr229505wrn.264.1568668299372;
 Mon, 16 Sep 2019 14:11:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190914004919.256530-1-marcorr@google.com> <6537afdb-2e0e-0933-3f7d-2a474378edf5@oracle.com>
In-Reply-To: <6537afdb-2e0e-0933-3f7d-2a474378edf5@oracle.com>
From:   Marc Orr <marcorr@google.com>
Date:   Mon, 16 Sep 2019 14:11:28 -0700
Message-ID: <CAA03e5E-rv+49X_qSukGwmP2z48GR4LCMM6dp3b2_QqC3f24Sw@mail.gmail.com>
Subject: Re: [kvm-unit-tests PATCH v2] x86: nvmx: test max atomic switch MSRs
To:     Krish Sadhukhan <krish.sadhukhan@oracle.com>
Cc:     kvm@vger.kernel.org, Jim Mattson <jmattson@google.com>,
        Peter Shier <pshier@google.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

> > v1 -> v2
> > * Replaced 2M page allocations with 128 kB allocations.
> > * Broadly, updated test to follow Sean's draft:
> >    * Got rid of loop + individual test cases. Instead combined all test cases.
> >    * Got rid of configure_atomic_switch_msr_limit_test().
> > * Updated cleanup code to free memory. I added a new helper,
> >    free_pages_by_order() to help here.
> > * Changed virt_to_phys() to explicit u64 cast.
> > * Renamed original test case from atomic_switch_msr_limit_test() to
> >    atomic_switch_max_msrs_test(). Added opt-in
> >    atomic_switch_overflow_msrs_test() test case to test failure code path
> >    during VM-entry.
> > * Fixed a bug in transitioning VMX launched state when the first
> >    VM-entry fails.
>
> Can we move this bug-fix to a separate patch so that it can be
> identified easily when searching in git history ?

SGTM. I'll wait to see if there are any more comments before splitting this out.
