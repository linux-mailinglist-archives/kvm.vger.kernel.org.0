Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75B66150FFC
	for <lists+kvm@lfdr.de>; Mon,  3 Feb 2020 19:52:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbgBCSw3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 3 Feb 2020 13:52:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:41636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727067AbgBCSw3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 3 Feb 2020 13:52:29 -0500
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 094AA20838
        for <kvm@vger.kernel.org>; Mon,  3 Feb 2020 18:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580755948;
        bh=pARSwgYkMBJyABhyHmnGARQ80UDtRTlxYaKZnCi/W8w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=X23f4DKcw/VO8i9LnkovXZU0Hoik5aH13r4f0uUQ5cMQWZ/Ok1NJ7rTfqQI6wdaU2
         ogIHhGOYhpMO3OFRKI1LtOsgYO7ogGe+8nyy3OfdspBZbcTe+jwfDj7FlrOh5rLEud
         I9dbBmi4OyAe7O+RPOWFpTkTXNe7Aq6fjnCNBq3w=
Received: by mail-wr1-f48.google.com with SMTP id y17so19680799wrh.5
        for <kvm@vger.kernel.org>; Mon, 03 Feb 2020 10:52:27 -0800 (PST)
X-Gm-Message-State: APjAAAVwStUvvlKpSRWpXA8ZD2LnnAONgKg+A2/ijuR7N9qq50k8r5gA
        SAAyAnNlniCjVbnyBJelOY8/Teb/40zZ4uuQISkMvw==
X-Google-Smtp-Source: APXvYqydAzYMpo7YlxsrmraMrL4WuCg4APe95PSY1AMc0UTpplvcfcM2vuUTrptlnD2VD/DLpbyclMaFWyipZ/AYPps=
X-Received: by 2002:a5d:4cc9:: with SMTP id c9mr16813882wrt.70.1580755946612;
 Mon, 03 Feb 2020 10:52:26 -0800 (PST)
MIME-Version: 1.0
References: <20200203151608.28053-1-xiaoyao.li@intel.com> <20200203151608.28053-7-xiaoyao.li@intel.com>
In-Reply-To: <20200203151608.28053-7-xiaoyao.li@intel.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 3 Feb 2020 10:52:15 -0800
X-Gmail-Original-Message-ID: <CALCETrVuWY4G9-h+m9XAZDscaRrtaZ-j-F_y3qHfENvMkr1g5Q@mail.gmail.com>
Message-ID: <CALCETrVuWY4G9-h+m9XAZDscaRrtaZ-j-F_y3qHfENvMkr1g5Q@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] x86: vmx: virtualize split lock detection
To:     Xiaoyao Li <xiaoyao.li@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Laight <David.Laight@aculab.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 3, 2020 at 7:21 AM Xiaoyao Li <xiaoyao.li@intel.com> wrote:
>
> Due to the fact that MSR_TEST_CTRL is per-core scope, i.e., the sibling
> threads in the same physical CPU core share the same MSR, only
> advertising feature split lock detection to guest when SMT is disabled
> or unsupported for simplicitly.
>
> Only when host is sld_off, can guest control the hardware value of
> MSR_TEST_CTL, i.e., KVM loads guest's value into hardware when vcpu is
> running.
>
> The vmx->disable_split_lock_detect can be set to true after unhandled
> split_lock #AC in guest only when host is sld_warn mode. It's for not
> burnning old guest, of course malicous guest can exploit it for DoS
> attack.

Is this actually worthwhile?  This only applies to the host having
sld=off or warn and the host having HT off.  I suspect that
deployments supporting migration will not want to use this, and
multi-tenant deployments won't want to use it for SLD-aware guests doe
to DoS risk.

--Andy
