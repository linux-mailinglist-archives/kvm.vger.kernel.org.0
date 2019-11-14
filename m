Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7866FBE75
	for <lists+kvm@lfdr.de>; Thu, 14 Nov 2019 04:51:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726590AbfKNDvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Nov 2019 22:51:22 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:35519 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbfKNDvW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Nov 2019 22:51:22 -0500
Received: by mail-oi1-f194.google.com with SMTP id n16so4024998oig.2;
        Wed, 13 Nov 2019 19:51:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oTNGunsWbSvt43YXzCeF3NH4k2942fdpf8D5q79SgVU=;
        b=O5PrQ1HOh6MNMvmynIQEo/A6e9bNN8fnEemRDCPzwTzD2yKvWxQKxLng92yJxCvFz/
         qXi05MCCH87j5JQIpPBroCsdIw0T+wMw1F4W6xtyxIyibZXGX4Vx90+fj+F2uKv9fiuJ
         +MUvoVWyZumwU6usy1VABi/N1rqD/m0JhQ8/fPDbN5coQvmDjq5pBoKtvE8MiSeyrDw1
         xT+BRZC8evgvljgk6bFkIzNZBmoRGCT92ZJD2GrQWmdtOPYlHozpSaVfERypfl8JuBgu
         7n97xgnsyIAwKWVdQXHyGcOZoHV98cymsiscF62QCpLo9sn+g1ltTQGh5ACreFZ9LF0f
         iuhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oTNGunsWbSvt43YXzCeF3NH4k2942fdpf8D5q79SgVU=;
        b=ouUIkXESd+bwE2060Z5ONd/wUTeTKYUGn8KhtWm3wlTbRyb9Xm/fldWtBgSF3mf5C/
         WKhrxNGxmYA4vua0fJR797qQbGwFSSw1tWlYeSHrrzUM4Gk/270ifNFhL+L2xtniM6xn
         nF7i5A+7nu12e2HV5LSWBQK3KaZ8yZD19VWgBNTAQC5qhXNeorgRLsbwHzPhjxuBfNy3
         X4pFCkgvcdndqVhQ5elRA2u0560vubDX4jieYqMaef/E4FkX2U7PyKnCy5g4Qzlj5ePU
         1qhEG/s01m+hvTNpoL6XcWQ4/JjjGBBCHPBlyKUU0J+9viZ1zqpQkiCGcySER1bqX2lp
         My3A==
X-Gm-Message-State: APjAAAUZyeBhOJQNcGniZyzjFjWCzsKZetkg1SuPz9eEDjG2Luhj/S/Z
        DEjTzAB8kOytvrX04lYrhtuYR84DIqBfzKFP/kM=
X-Google-Smtp-Source: APXvYqw45OVhkbExH5Ht9xrBIfcFTRS31ZX0p/sarKxNI/uKsFGLBBXd09EfpuoOJZA2zzohS12ILdfi/EdXNrjyqWg=
X-Received: by 2002:aca:39d6:: with SMTP id g205mr1735278oia.33.1573703481267;
 Wed, 13 Nov 2019 19:51:21 -0800 (PST)
MIME-Version: 1.0
References: <20191027105243.34339-1-like.xu@linux.intel.com> <20191027105243.34339-6-like.xu@linux.intel.com>
In-Reply-To: <20191027105243.34339-6-like.xu@linux.intel.com>
From:   Wanpeng Li <kernellwp@gmail.com>
Date:   Thu, 14 Nov 2019 11:51:11 +0800
Message-ID: <CANRm+Cz3-k6Bct0JAN=m1emT5j4NgULjURyHz0vCDabq00nk4Q@mail.gmail.com>
Subject: Re: [PATCH v4 5/6] KVM: x86/vPMU: Reuse perf_event to avoid
 unnecessary pmc_reprogram_counter
To:     Like Xu <like.xu@linux.intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jim Mattson <jmattson@google.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Joerg Roedel <joro@8bytes.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>, kan.liang@intel.com,
        wei.w.wang@intel.com, LKML <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, 28 Oct 2019 at 21:06, Like Xu <like.xu@linux.intel.com> wrote:
>
> The perf_event_create_kernel_counter() in the pmc_reprogram_counter() is
> a heavyweight and high-frequency operation, especially when host disables
> the watchdog (maximum 21000000 ns) which leads to an unacceptable latency

Why when host disables the watchdog,
perf_event_create_kernel_counter() is more heavyweight and
high-frequency operation?

    Wanpeng
