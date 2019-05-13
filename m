Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD40C1BD16
	for <lists+kvm@lfdr.de>; Mon, 13 May 2019 20:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfEMSSz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 13 May 2019 14:18:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54062 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726238AbfEMSSy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 13 May 2019 14:18:54 -0400
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 142DD216FD
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 18:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557771534;
        bh=0D70YYCaYJ/0FfOh4xzmgNQF/8UOkldQ6uPFbgG5pwI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=VJfYnS+5yGbxOPZ/IrGIvPvGQ3MWsey8Zcw2ynEdyFK0bMhb6EA9kn+qh0dub8jNy
         BUnM34hwwZ1Svmkf5b+KeyY5QW3SWsWXC0ncGsSlKjnU7m5z/A5Z5cT9X6y3liCLay
         edErDf2BS2T6yENCy2PLIQTWiBRyIZLCTwIbQJ9Q=
Received: by mail-wr1-f50.google.com with SMTP id w8so13931490wrl.6
        for <kvm@vger.kernel.org>; Mon, 13 May 2019 11:18:54 -0700 (PDT)
X-Gm-Message-State: APjAAAXI0ZWpbZDQRC/GTYs8f1eQhLYNmf4pfk37R8Dk8L5XA4fx8w45
        CZyYAcP1O2UQZLorRmp+itkUrJlXzLjH6gJjvw1L6Q==
X-Google-Smtp-Source: APXvYqzMD+jfx2qmw89VL/y5TnHwYxBELfM91Gqw/WyfcWG/E3PFqI1sA/Of9WWBUTt1ciqS571lZ9PBkV9nJFeVHas=
X-Received: by 2002:adf:ec42:: with SMTP id w2mr17777817wrn.77.1557771532684;
 Mon, 13 May 2019 11:18:52 -0700 (PDT)
MIME-Version: 1.0
References: <1557758315-12667-1-git-send-email-alexandre.chartre@oracle.com> <1557758315-12667-19-git-send-email-alexandre.chartre@oracle.com>
In-Reply-To: <1557758315-12667-19-git-send-email-alexandre.chartre@oracle.com>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Mon, 13 May 2019 11:18:41 -0700
X-Gmail-Original-Message-ID: <CALCETrWUKZv=wdcnYjLrHDakamMBrJv48wp2XBxZsEmzuearRQ@mail.gmail.com>
Message-ID: <CALCETrWUKZv=wdcnYjLrHDakamMBrJv48wp2XBxZsEmzuearRQ@mail.gmail.com>
Subject: Re: [RFC KVM 18/27] kvm/isolation: function to copy page table
 entries for percpu buffer
To:     Alexandre Chartre <alexandre.chartre@oracle.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Radim Krcmar <rkrcmar@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Andrew Lutomirski <luto@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        kvm list <kvm@vger.kernel.org>, X86 ML <x86@kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        jan.setjeeilers@oracle.com, Liran Alon <liran.alon@oracle.com>,
        Jonathan Adams <jwadams@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, May 13, 2019 at 7:39 AM Alexandre Chartre
<alexandre.chartre@oracle.com> wrote:
>
> pcpu_base_addr is already mapped to the KVM address space, but this
> represents the first percpu chunk. To access a per-cpu buffer not
> allocated in the first chunk, add a function which maps all cpu
> buffers corresponding to that per-cpu buffer.
>
> Also add function to clear page table entries for a percpu buffer.
>

This needs some kind of clarification so that readers can tell whether
you're trying to map all percpu memory or just map a specific
variable.  In either case, you're making a dubious assumption that
percpu memory contains no secrets.
