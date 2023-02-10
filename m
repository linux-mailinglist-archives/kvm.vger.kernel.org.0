Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAB2691EC9
	for <lists+kvm@lfdr.de>; Fri, 10 Feb 2023 13:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbjBJMB4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Feb 2023 07:01:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232235AbjBJMBt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Feb 2023 07:01:49 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47F21B6D73
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 04:01:39 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id x4so6106531ybp.1
        for <kvm@vger.kernel.org>; Fri, 10 Feb 2023 04:01:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=1jwrQQNf1AnNFQoY1CSsZGZlA1OyRM3AQRwMVKGcGFE=;
        b=VzJJrY1czOnLI9zserZvykrCI4wQ1fcILGSc9Z8/fJIfT05M6hIIAQLvc9FQdyKLkI
         tvSsySFDam20WtD8cxWf1JdXg5Z3Z3fS0/qxL9Fkd/sARb/Xj8DPoHRqtWrYQpdHxlbw
         b7TuZb3tV/TQ4082VejWZYsD7EpVNggjx6Ic2WeqCXlN+ZAtfEnKwabrnmmdvQuT2EAI
         QjaAHaHuz01QtkFlynN6uBYdm+qOmRT/AYGI3/YTqqxoZWmkpraKFUxMUawa38Z5KzzE
         6qxAN7htjNkaVbPNe6YcJZCL8jSm5Afl595a2ZXxP5RWgqfqlWcT1sukaJURnbUZtsza
         ghJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1jwrQQNf1AnNFQoY1CSsZGZlA1OyRM3AQRwMVKGcGFE=;
        b=qe5YAwPA7d8xYM2mRUMTSod2fpDekBiHMcnvJcp227lUHkH3W0Md8pmey+SlRk3kRp
         et2GjLS8Dy98EXR7290NbEEZyCkLig6uuKr5An/uLrngNxnuss2LajpD0AzrRlDAs+RU
         /qQCOzz16hx6kc4ObfKmemPaaKMRMhsDADjQHiEG2YhRlwT5OytoV6rLWDgUCEIGyu7k
         jKoHtuEZrrQ1K0bRykdUNn/b0O3u9g5hb1o3b8Ub1JKjpcZsxNEw69+DWSVDNRqY8hJV
         M9Wtg5ZLIb8RUtvlZ+n8gFQpE/PmMxa7336hXsPbXRFbQ2WgHAZvvw4zrsB4j7PVysO4
         S6qw==
X-Gm-Message-State: AO0yUKVHAl2cU314Mab4j2Bqghi4qEOm3VIvvLZUSoFcnoSEf1HiI2yi
        tRMAM565B101nv8QzGW86izHupE9sKCOX2+pH56xuw==
X-Google-Smtp-Source: AK7set9qynGF/Sxd+zA/Vyt+YbgEjGY7FcWEXpsQ103JEwyyPC23370Zjfe5WzDNa+02nvNq74+n690DSsNrLEMYRbY=
X-Received: by 2002:a05:6902:4c5:b0:8c7:f1f7:35a2 with SMTP id
 v5-20020a05690204c500b008c7f1f735a2mr930408ybs.541.1676030498397; Fri, 10 Feb
 2023 04:01:38 -0800 (PST)
MIME-Version: 1.0
References: <20230125142056.18356-1-andy.chiu@sifive.com> <20230125142056.18356-11-andy.chiu@sifive.com>
 <Y9MIr2iR5rzlIGKQ@spud> <CABgGipW_3tBbc3G91dqiAZCGeN-PbUvLS3n=bU0nWz0rRX9T8Q@mail.gmail.com>
 <36A0C855-5EA7-49B5-B92E-B28E684AC3D8@kernel.org>
In-Reply-To: <36A0C855-5EA7-49B5-B92E-B28E684AC3D8@kernel.org>
From:   Andy Chiu <andy.chiu@sifive.com>
Date:   Fri, 10 Feb 2023 20:00:00 +0800
Message-ID: <CABgGipXMwnVPFY3D34zVQ1_MObYiYze-vvU23_yC12Q+xN+1ew@mail.gmail.com>
Subject: Re: [PATCH -next v13 10/19] riscv: Allocate user's vector context in
 the first-use trap
To:     Conor Dooley <conor@kernel.org>
Cc:     linux-riscv@lists.infradead.org, palmer@dabbelt.com,
        anup@brainfault.org, atishp@atishpatra.org,
        kvm-riscv@lists.infradead.org, kvm@vger.kernel.org,
        vineetg@rivosinc.com, greentime.hu@sifive.com,
        guoren@linux.alibaba.com, Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Heiko Stuebner <heiko.stuebner@vrull.eu>,
        Andrew Jones <ajones@ventanamicro.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Conor Dooley <conor.dooley@microchip.com>,
        Jisheng Zhang <jszhang@kernel.org>,
        Vincent Chen <vincent.chen@sifive.com>,
        Guo Ren <guoren@kernel.org>,
        Li Zhengyu <lizhengyu3@huawei.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Changbin Du <changbin.du@intel.com>,
        Richard Henderson <richard.henderson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Feb 6, 2023 at 9:40 PM Conor Dooley <conor@kernel.org> wrote:
> I suppose my question was "is it safe to warn and carry on, rather than disallow use of vector in this situation".
Yes, I think it is safe to warn and carry on. This is a check for
memory leak if future code did not allocate/free datap correctly.

Thanks,
Andy
