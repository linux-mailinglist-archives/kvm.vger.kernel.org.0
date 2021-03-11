Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D806336965
	for <lists+kvm@lfdr.de>; Thu, 11 Mar 2021 02:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbhCKBGA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 10 Mar 2021 20:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhCKBFY (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 10 Mar 2021 20:05:24 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35239C061574;
        Wed, 10 Mar 2021 17:05:24 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id f10so17428686ilq.5;
        Wed, 10 Mar 2021 17:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=tzLcpbEHlICK/TY3veXTxXrzL8MkHekFvgC0dEJ6xUY=;
        b=LZBOFnzlnL8BCHZYy2gxCniNTx8DL20WUALibFUmm2iub0s76sHOMehyxztAiu90NF
         bo5viCGgzdHJFUlaV3nPaCd9YSTdXCl94XRILUQT4MbA9Hg1i2gFq7hjyk3TSkQXe5o0
         0j+3IS/hp3G0YuU8WDvDjXyGSG5rL8sh1Ll4D6GtDa5UL/4ZPHcdbQl8VKPI8oP3SqNH
         NrIHlUMxzQKnjdH8POjHlTibZIMzz2EVlXcyhF6eKyqyuHl89tIZVkX46OnkDtBurmKa
         6csBLXxCefF/9gYoCVFAsFDH2vd1+s3LXFi8gfDyse3VUc0JkBMLqUHIG9oh+LIzcoNt
         DA4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=tzLcpbEHlICK/TY3veXTxXrzL8MkHekFvgC0dEJ6xUY=;
        b=fw1ABzTUrANiafdG10Vwaki6Prn3OTH/00pyHqvkN67XV/HA1DzMKLsjTJJ8PKJS6G
         2gs7Ov+Mu/nUJykPBOI5rIoAX323xuZ/KHNfEhJlucU7GqNQHZ9hPeVe0KOqOV29q8q0
         p7Xn4WQwo9mmZJmVEc1Desk4gL/0ZvtPFdtkjxMPKgUqn8Iw8+5tix3bXHD7Naelyqlk
         Z+Mxulvhs6jk/2xkrJgXFS1HImBRME3Meb9SRLtIjof2kh1heXePZ3BinvADWNCOzrbQ
         EtXFobaXTt1w7j+vR6rd8PxDJkDQQCcckzCN0FgJRWMqrsLClVEvMcahZGvQQz0UW9JU
         L/nA==
X-Gm-Message-State: AOAM531v/hVJlRNuKvc1gvmWcDYH1d2KvxgGIrBxgswcknzXpnPI+nOk
        KI+mCqewnToKC5V69fUECIOm1FPGUiFil6puDGA=
X-Google-Smtp-Source: ABdhPJygjZiXjz3N6qVWwrLUn617NgpkFbTB7aeFU0n7/FT/9HvsgsOtss8INOhAOhrg8Bm9D/+acdHqQLrNKB/mbmE=
X-Received: by 2002:a92:c04b:: with SMTP id o11mr4720645ilf.42.1615424723613;
 Wed, 10 Mar 2021 17:05:23 -0800 (PST)
MIME-Version: 1.0
References: <A221FEC9-71CE-4D0A-9F39-F75C337B5D22@contoso.com>
In-Reply-To: <A221FEC9-71CE-4D0A-9F39-F75C337B5D22@contoso.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Wed, 10 Mar 2021 17:05:12 -0800
Message-ID: <CAKgT0Ud508jLc4NVm1XxNSjEnq3NoLS=Q1V+o=6JZoJF_r_m0A@mail.gmail.com>
Subject: Re: [PATCH v17 1/9] mm: Adjust shuffle code to allow for future coalescing
To:     "Bodeddula, Balasubramaniam" <bodeddub@amazon.com>
Cc:     "aarcange@redhat.com" <aarcange@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "alexander.h.duyck@linux.intel.com" 
        <alexander.h.duyck@linux.intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "david@redhat.com" <david@redhat.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "lcapitulino@redhat.com" <lcapitulino@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "mgorman@techsingularity.net" <mgorman@techsingularity.net>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "nitesh@redhat.com" <nitesh@redhat.com>,
        "osalvador@suse.de" <osalvador@suse.de>,
        "pagupta@redhat.com" <pagupta@redhat.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "riel@surriel.com" <riel@surriel.com>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "wei.w.wang@intel.com" <wei.w.wang@intel.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "yang.zhang.wz@gmail.com" <yang.zhang.wz@gmail.com>,
        "Graf (AWS), Alexander" <graf@amazon.de>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi Bala,

There was a similar effort several months ago that was trying to do
this in conjunction with pre-zeroing of pages. I suspect if you wanted
to you could probably pick up some of their patch set and work with
that. It can be found at:
https://www.spinics.net/lists/linux-mm/msg239735.html

Thanks.

- Alex

On Tue, Mar 9, 2021 at 12:13 AM Bodeddula, Balasubramaniam
<bodeddub@amazon.com> wrote:
>
> Hi Alexander,
>
>
>
> My team was evaluating FPR and observed that these patches don=E2=80=99t =
report memory for deallocated hugeapages directly and need to cycle through=
 buddy allocator. For example, say we need to allocate a maximum of 12 * 1G=
 hugepages (by setting nr_hugepages), use 8 * 1G hugepages, and then deallo=
cate 4 * 1G hugepages. Unlike regular 4K pages, this 4G worth of memory wil=
l not be reported until we set nr_hugepages to 8 (wait sometime(?) for FPR =
to do its work) and set it back again to 12. While this works fine in theor=
y, in practice,  setting nr_hugepages to 12 could fail too due to fragmenta=
tion (this could depend on other processes memory usage behavior).
>
>
>
> If FPR could report this free memory without cycling through buddy alloca=
tor, it makes the solution more robust. I am looking for advice on how feas=
ible this approach is and what would be the effort for building this functi=
onality. In general, if there are other thoughts on how we can address this=
, please do let me know.
>
>
>
> Thanks,
>
> bala
