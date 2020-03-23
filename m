Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0736418F9A1
	for <lists+kvm@lfdr.de>; Mon, 23 Mar 2020 17:24:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgCWQYi (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Mar 2020 12:24:38 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39598 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725893AbgCWQYi (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Mar 2020 12:24:38 -0400
Received: by mail-io1-f68.google.com with SMTP id c19so14751868ioo.6
        for <kvm@vger.kernel.org>; Mon, 23 Mar 2020 09:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=szMpm1YHgB+ek/GLf0Q9znil+A6chCIsHv9XnjC6wnU=;
        b=hK+AE+H5QEe79Ixitmvqv2R3HJWBBiY+uk5cy6vqPzyp6RRYzVKOY1yI6KN9ITyiDl
         rHVf7JZXS+6XiwgQCmg3Qk2K1zUoxMyRqBFZO3ShH1a3vIdyQ+6ui55W9Y1WgD3AV80G
         4FsIYQ8PNslp31hPnLuC/M29GplL1v6q7549yAHCOdLUNCM3bnev4A1n4NRGDqdRa545
         jBfx/r7xmzNAVda7gngzIjz/zjmlf8NcJIDD4XIh8IBejiDVjZiV5/uq3gvdYBdrCkwU
         ubfJWq5Vz0UltwxYBvtUqzhL7INCSnCsNez4NvSYbOz0WVZiGmzDeC8oHxHfnt+qkbHc
         A8Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=szMpm1YHgB+ek/GLf0Q9znil+A6chCIsHv9XnjC6wnU=;
        b=cn8y58jL5rbcWWG4tEoUuixTWtWkUyQ+TD+qhXHScugK/xmlLqQm8T2cbBU9z5A1tE
         03JpvFg2wGCNIQsNduZhse+qamjIkYalIm3t/PHhkxsP3NHyXLL9i+xrVcQWPi3PkaXk
         YJLMv447xUgR30uk2OJS+5eeSaYH6jHODh2FSviWQ1kbvPgeL4ICLoGuksrzpNEa9D3g
         JMZPlyhum8XrPQbT8SSN2qgnQxxRNK8U1uQNL4oFSx7pcREpdRZCTQNEIfFlLz61/HYa
         yJP4uESkKyHtdabNqPW2vg8oHdAzca5QlLw6V9r9llYUh7ouPC/8q9BqTwclsNfGtczT
         hAFg==
X-Gm-Message-State: ANhLgQ3Q+AieVjW9wFIOGPuQeAPbjWGUpStk+hW7HDzGjed/wXiOHhqy
        IBctKVCVOqbgCcgH5+6CM73AvEgts/9xO0evpzOQDA==
X-Google-Smtp-Source: ADFU+vus/6qIchDGH8hxBBNtI6zsWwfXLYMmjF5wwgd0drF19BSkmHMMb6n8O5PXjqQkAtnJaxYvTdHsE0KjN2GWnfE=
X-Received: by 2002:a6b:c408:: with SMTP id y8mr2864354ioa.12.1584980676836;
 Mon, 23 Mar 2020 09:24:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200320212833.3507-1-sean.j.christopherson@intel.com> <20200320212833.3507-4-sean.j.christopherson@intel.com>
In-Reply-To: <20200320212833.3507-4-sean.j.christopherson@intel.com>
From:   Jim Mattson <jmattson@google.com>
Date:   Mon, 23 Mar 2020 09:24:25 -0700
Message-ID: <CALMp9eR5Uu7nRDOS2nQHGzb+Gi6vjDEk1AmuiqkkGWFjKNG+sA@mail.gmail.com>
Subject: Re: [PATCH v3 03/37] KVM: nVMX: Invalidate all EPTP contexts when
 emulating INVEPT for L1
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm list <kvm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Gardon <bgardon@google.com>,
        Junaid Shahid <junaids@google.com>,
        Liran Alon <liran.alon@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        John Haxby <john.haxby@oracle.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Tom Lendacky <thomas.lendacky@amd.com>
Content-Type: text/plain; charset="UTF-8"
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Mar 20, 2020 at 2:29 PM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Free all L2 (guest_mmu) roots when emulating INVEPT for L1.  Outstanding
> changes to the EPT tables managed by L1 need to be recognized, and
> relying on KVM to always flush L2's EPTP context on nested VM-Enter is
> dangerous.
>
> Similar to handle_invpcid(), rely on kvm_mmu_free_roots() to do a remote
> TLB flush if necessary, e.g. if L1 has never entered L2 then there is
> nothing to be done.
>
> Nuking all L2 roots is overkill for the single-context variant, but it's
> the safe and easy bet.  A more precise zap mechanism will be added in
> the future.  Add a TODO to call out that KVM only needs to invalidate
> affected contexts.
>
> Fixes: b119019847fbc ("kvm: nVMX: Remove unnecessary sync_roots from handle_invept")

The bug existed well before the commit indicated in the "Fixes" line.
