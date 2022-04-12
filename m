Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 826294FE93F
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 22:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232710AbiDLUGk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 16:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232702AbiDLUGQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 16:06:16 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A1548300B
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 12:57:28 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id 17so25451883lji.1
        for <kvm@vger.kernel.org>; Tue, 12 Apr 2022 12:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KPcbiORevCwEqMtvKJH++KF0drE74ilJoT8gFQ34EnA=;
        b=TSKs9eKW1GlEw++EEPezIbQGa8d6xcrKEr3la4XqzpfJPISA+7b9KTTEm23XMMJ1YV
         pcXKlpyq55urGdORKzGxmT1pTvZ/5QXhjKImBF6bFGimi25oLZDpt9M2DbzXX/bDQ+u3
         9OTNzI18CY7dO2LOX4qCsPXJJ34xmRx72tFYZ9ATSXhsUXzw1klZnP3cX0EZtk+eprNZ
         tCkMhSq3MAlnJi4/eKNm3VReaN0l0QUhoN+OmB8jE4MWy6cl5AMOOOgXwh+tCG2JI/WG
         9+gYtMY/ams5vv8fDesBL9oYXhTRQRnTpXvK1Fa0yRuSW4SuRnnTGhhsM6HBGKFzDmOM
         KMVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KPcbiORevCwEqMtvKJH++KF0drE74ilJoT8gFQ34EnA=;
        b=6qLrtZhXw4z0AU6TzrbbuH4DJwN2CIOq4kceWid7dZqpjZvhkATllGGmFjgkQwHlDT
         kQq5RzhM4Qem8eI7t3Mqq/etHem3BJQptaESP5f5dIElGTwaZ5vtzvBxwI+tbXqoGBQp
         N4z7C/Pluq3NNd5I9xzRTJwdnc9J6juKEEer/MvNKEXDuyq/o2GyV9HGa1ECQVGI/7ST
         8kdZ2f9TOlNp+L89jI3uFe1gq4NI/YNpG6Bo0qILylp2YmJw8sJZugSbonKCN310C3PL
         jqM7zuGfUSbl+CgloPKgTcoZdLntZk2J3M6SgdpePBVAH+Eb1O42mO6ZDO0UwBuhD8mU
         Q5iw==
X-Gm-Message-State: AOAM532V+2VLKQoG8fiG48ddA7lFqCJPG96Ij4O2jWtkx2hxYErRqUhJ
        3GKBLCdnosxDnMAOao4wiY1Y4w==
X-Google-Smtp-Source: ABdhPJzmo2kVaO0teoqOt46A1/R+kt5G8p3jezRBHquWD+rDhCqurcBAW6KPrG7h2kWuiHcT+suCXg==
X-Received: by 2002:a2e:a795:0:b0:24c:7f68:b382 with SMTP id c21-20020a2ea795000000b0024c7f68b382mr1118017ljf.494.1649793446359;
        Tue, 12 Apr 2022 12:57:26 -0700 (PDT)
Received: from box.localdomain ([86.57.175.117])
        by smtp.gmail.com with ESMTPSA id g4-20020ac24d84000000b00464f178c0bbsm1843697lfe.96.2022.04.12.12.57.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 12:57:25 -0700 (PDT)
Received: by box.localdomain (Postfix, from userid 1000)
        id 446751030D2; Tue, 12 Apr 2022 22:58:59 +0300 (+03)
Date:   Tue, 12 Apr 2022 22:58:59 +0300
From:   "Kirill A. Shutemov" <kirill@shutemov.name>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Chao Peng <chao.p.peng@linux.intel.com>,
        Wanpeng Li <wanpengli@tencent.com>, jun.nakajima@intel.com,
        kvm@vger.kernel.org, david@redhat.com, qemu-devel@nongnu.org,
        "J . Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org,
        "H . Peter Anvin" <hpa@zytor.com>, ak@linux.intel.com,
        Jonathan Corbet <corbet@lwn.net>,
        Joerg Roedel <joro@8bytes.org>, x86@kernel.org,
        Hugh Dickins <hughd@google.com>,
        Steven Price <steven.price@arm.com>,
        Ingo Molnar <mingo@redhat.com>,
        "Maciej S . Szmigiero" <mail@maciej.szmigiero.name>,
        Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Jim Mattson <jmattson@google.com>, dave.hansen@intel.com,
        linux-api@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        linux-kernel@vger.kernel.org,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Sean Christopherson <seanjc@google.com>,
        linux-fsdevel@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vishal Annapurve <vannapurve@google.com>,
        Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH v5 00/13] KVM: mm: fd-based approach for supporting KVM
 guest private memory
Message-ID: <20220412195859.gjklfw3fz2lehpb5@box.shutemov.name>
References: <20220310140911.50924-1-chao.p.peng@linux.intel.com>
 <CALCETrWk1Y47JQC=V028A7Tmc9776Oo4AjgwqRtd9K=XDh6=TA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWk1Y47JQC=V028A7Tmc9776Oo4AjgwqRtd9K=XDh6=TA@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Mar 28, 2022 at 01:16:48PM -0700, Andy Lutomirski wrote:
> On Thu, Mar 10, 2022 at 6:09 AM Chao Peng <chao.p.peng@linux.intel.com> wrote:
> >
> > This is the v5 of this series which tries to implement the fd-based KVM
> > guest private memory. The patches are based on latest kvm/queue branch
> > commit:
> >
> >   d5089416b7fb KVM: x86: Introduce KVM_CAP_DISABLE_QUIRKS2
> 
> Can this series be run and a VM booted without TDX?  A feature like
> that might help push it forward.

It would require enlightenment of the guest code. We have two options.

Simple one is to limit enabling to the guest kernel, but it would require
non-destructive conversion between shared->private memory. This does not
seem to be compatible with current design.

Other option is get memory private from time 0 of VM boot, but it requires
modification of virtual BIOS to setup shared ranges as needed. I'm not
sure if anybody volunteer to work on BIOS code to make it happen.

Hm.

-- 
 Kirill A. Shutemov
