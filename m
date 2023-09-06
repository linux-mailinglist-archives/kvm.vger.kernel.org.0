Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A75179434A
	for <lists+kvm@lfdr.de>; Wed,  6 Sep 2023 20:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243927AbjIFSvW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 6 Sep 2023 14:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238438AbjIFSvV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 6 Sep 2023 14:51:21 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B240173B
        for <kvm@vger.kernel.org>; Wed,  6 Sep 2023 11:51:15 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1c1e780aa95so896935ad.3
        for <kvm@vger.kernel.org>; Wed, 06 Sep 2023 11:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1694026275; x=1694631075; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gQpveLuX0FUvjuwD4dGyYyZDS0eYrWbcLN2fWSij0iA=;
        b=Lh0njkiDXqesDcF9F0sgQ8qNf8dF/hxEm1Qdu+MbfJRZz9LqnrbQ/QRx95daGo5wz8
         Lu7g9/4LSvLtckW/TrKwjJg3kN9T0OHkikwlOVni9hqMCVKyI4OSx79sm3ujH43Sznap
         zTQwgb47CUqcj9injRxBRFpVi82H5CnN6bGIW+AFr14hpCF8p7vPAI+2eQ5YC9qjUIPf
         19CjCDdDpOS5uLWQOW0j1Pih7yUl00SPyCYO0/F/ZKAZEELVhd9To9fN/7l6KejyoDc/
         CIT5Lun9q24BWjth30peIQVlTNOo/7iQk9QJOA6dR94XFdtdZ4hfQL13J1Vdxku3qHv2
         iUqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1694026275; x=1694631075;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gQpveLuX0FUvjuwD4dGyYyZDS0eYrWbcLN2fWSij0iA=;
        b=YuNbom4hMdvASOBC036lgdQ5H6B/zJb/lrrlBm+ODRNYPotePT2637+E2xBgbhha2K
         6dph9LyxIW6O27aASol1fhDIphWQzKmFZABIlOBbxeJDfyxLzAATxyZ/15MIfoid4kbt
         oLuAh1YuBxda/SjhawfYrB+40GyXtQ190Ld8MMZQlpMa701RI4APEn8HS0hCJjuDoXmm
         xcrH6VDTgob7w/CYOHhlgyOhLRGA4OAn79UGkoPClTqUXx1j08T7FH4qHvS2oGbq7sqP
         8ZTeXAoF1IoVTBINE50HOu6AWRrNPELeVsyfZoLzQmYIv/u45hBNW5qM1SA0j7bLlJNN
         vfYg==
X-Gm-Message-State: AOJu0Yy6F0MG0ZVCZxiy6bDQfF2/X6PHR3t4umxEpdA+DzjNypsNqQ3t
        +HBRqw9b7HAUE5wncxI0Ont0ug==
X-Google-Smtp-Source: AGHT+IHUCKPBvm+y4ZSnJx6E4oEoYCsWpR9RPBg93vTI0YIyf1mDbs5Z8RbtKmorODld7KsvQCj4Fg==
X-Received: by 2002:a17:902:dad2:b0:1c3:5f05:922a with SMTP id q18-20020a170902dad200b001c35f05922amr2910308plx.60.1694026274955;
        Wed, 06 Sep 2023 11:51:14 -0700 (PDT)
Received: from ghost ([50.221.140.188])
        by smtp.gmail.com with ESMTPSA id g14-20020a1709029f8e00b001befac3b3cbsm11407084plq.290.2023.09.06.11.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Sep 2023 11:51:14 -0700 (PDT)
Date:   Wed, 6 Sep 2023 11:51:05 -0700
From:   Charlie Jenkins <charlie@rivosinc.com>
To:     Andrew Jones <ajones@ventanamicro.com>
Cc:     Palmer Dabbelt <palmer@dabbelt.com>, jrtc27@jrtc27.com,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, kvm-riscv@lists.infradead.org,
        bpf@vger.kernel.org, Paul Walmsley <paul.walmsley@sifive.com>,
        aou@eecs.berkeley.edu, peterz@infradead.org, jpoimboe@kernel.org,
        jbaron@akamai.com, rostedt@goodmis.org,
        Ard Biesheuvel <ardb@kernel.org>, anup@brainfault.org,
        atishp@atishpatra.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, martin.lau@linux.dev, song@kernel.org,
        yhs@fb.com, john.fastabend@gmail.com, kpsingh@kernel.org,
        sdf@google.com, haoluo@google.com, jolsa@kernel.org,
        bjorn@kernel.org, luke.r.nels@gmail.com, xi.wang@gmail.com,
        namcaov@gmail.com
Subject: Re: [PATCH 00/10] RISC-V: Refactor instructions
Message-ID: <ZPjKGd7VstwIKDV5@ghost>
References: <ZN5OJO/xOWUjLK2w@ghost>
 <mhng-7d609dde-ad47-42ed-a47b-6206e719020a@palmer-ri-x1c9a>
 <20230818-63347af7195b7385c146778d@orel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230818-63347af7195b7385c146778d@orel>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Aug 18, 2023 at 09:30:32AM +0200, Andrew Jones wrote:
> On Thu, Aug 17, 2023 at 10:52:22AM -0700, Palmer Dabbelt wrote:
> > On Thu, 17 Aug 2023 09:43:16 PDT (-0700), Charlie Jenkins wrote:
> ...
> > > It seems to me that it will be significantly more challenging to use
> > > riscv-opcodes than it would for people to just hand create the macros
> > > that they need.
> > 
> > Ya, riscv-opcodes is pretty custy.  We stopped using it elsewhere ages ago.
> 
> Ah, pity I didn't know the history of it or I wouldn't have suggested it,
> wasting Charlie's time (sorry, Charlie!). So everywhere that needs
> encodings are manually scraping them from the PDFs? Or maybe we can write
> our own parser which converts adoc/wavedrom files[1] to Linux C?
> 
> [1] https://github.com/riscv/riscv-isa-manual/tree/main/src/images/wavedrom

The problem with the wavedrom files is that there are no standard for
how each instruction is identified. The title of of the adoc gives some
insight and there is generally a funct3 or specific opcode that is
associated with the instruction but it would be kind of messy to write a
script to parse that. I think manually constructing the instructions is
fine. When somebody wants to add a new instruction they probably will
not need to add very many at a time, so it should be only a couple of
lines that they will be able to test.

> 
> Thanks,
> drew
