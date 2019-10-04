Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE334CC67F
	for <lists+kvm@lfdr.de>; Sat,  5 Oct 2019 01:27:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731387AbfJDX1I (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 4 Oct 2019 19:27:08 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:43484 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729968AbfJDX1H (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 4 Oct 2019 19:27:07 -0400
Received: by mail-io1-f66.google.com with SMTP id v2so17019375iob.10
        for <kvm@vger.kernel.org>; Fri, 04 Oct 2019 16:27:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MgBtF74uU/h5axnlk7JkCOLmu+x1dOiph+vzsmYmvXk=;
        b=uVq6fcbrUf2k6Z02rKXUYQfm+NxJ2X43dktUoENxNfmYB2XHRk95SxYzgRSsUxbcrB
         VMY+k9uQhD+yw7Z86iccSLyRvIZnFRWINVLQMCAnizvTboxDa8tSgunhpBqy399TufJo
         pTQgwsr0b4UWFteBOPGCKp4iaOAJbfAmgi0akHoXxFyE+3Odreox81GbAtjlHVpI3px2
         Vbo5DzvIn0o5B/YPL/oms2GZI0hF4ZHLN5W6SagkqSMqr/NrriKUAizDRFMfuWBMfg3o
         h5rMM9AS6TZh1Fjlyk+8lgmSMuV6Io0A48BTiKiatBflNxygHw3HopbT40WTIM5nuhhh
         6BsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MgBtF74uU/h5axnlk7JkCOLmu+x1dOiph+vzsmYmvXk=;
        b=rQL6vUqHtxH2KATQjZTkrSNLWf02eRynBZo6daoCJ9C4ZYLVBASQ2SzM4ksFymBvBq
         onezrK7rm6+Rfz+i2ezwkWXgeLzk7Csq5O/uTP748INMQHpsqL/MYzl3NVyTN9EtTf52
         VkwaY5MC848BDUFzuzSilhk2Zslln0D0WBuxcgDYOqXWWRhk+aJ6Qx5euGYHN91zsIo6
         nilPsoO47Y6e1H2XkcZ8T4wJLPis9sC2PPuRwwTozsOUsoWWYvDoe+mk4S2XZddHs1Sa
         qfl/IAMImC2NDtCIkI/2jGo3bs02FIy9QbQHiYa18UveFEvU9r8VPakiEJegUVLeomHg
         8snQ==
X-Gm-Message-State: APjAAAUrBzYD7p/MEnPl4/V088sXl9NrjMLBriXyWwz0A7AdZ/tHXFSx
        Q/WYJvT+MuHx7am2lyGuGZBln7x3gsbkXJqTzf+gMw==
X-Google-Smtp-Source: APXvYqzJcQzvaX5CC41I1TRQRNaPDPcG28y+blJrc8QdeTRZXOhchbrBqUvMeJR9kiv9S7ucRVxFUERN4ZPen7d4jzw=
X-Received: by 2002:a05:6638:3:: with SMTP id z3mr17415762jao.54.1570231626712;
 Fri, 04 Oct 2019 16:27:06 -0700 (PDT)
MIME-Version: 1.0
References: <20191004215615.5479-1-sean.j.christopherson@intel.com> <20191004215615.5479-8-sean.j.christopherson@intel.com>
In-Reply-To: <20191004215615.5479-8-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Fri, 4 Oct 2019 16:26:55 -0700
Message-ID: <CALMp9eRDxHAAbtvdUZyM2VyKiKhRxftW+zbmGANF6Y6qADK9_g@mail.gmail.com>
Subject: Re: [PATCH 07/16] KVM: VMX: Use VMX feature flag to query BIOS enabling
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Tony W Wang-oc <TonyWWang-oc@zhaoxin.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>,
        LKML <linux-kernel@vger.kernel.org>,
        kvm list <kvm@vger.kernel.org>, linux-edac@vger.kernel.org,
        Borislav Petkov <bp@suse.de>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 4, 2019 at 2:56 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Replace KVM's manual checks on IA32_FEATURE_CONTROL with a query on the
> boot CPU's VMX feature flag.  The VMX flag is now cleared during boot if
> VMX isn't fully enabled via IA32_FEATURE_CONTROL, including the case
> where IA32_FEATURE_CONTROL isn't supported.
>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
