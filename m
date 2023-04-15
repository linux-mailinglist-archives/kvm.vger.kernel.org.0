Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9176E2ECE
	for <lists+kvm@lfdr.de>; Sat, 15 Apr 2023 05:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjDODaU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 14 Apr 2023 23:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDODaR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 14 Apr 2023 23:30:17 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EFC75262;
        Fri, 14 Apr 2023 20:30:17 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id l9-20020a17090a3f0900b0023d32684e7fso9873104pjc.1;
        Fri, 14 Apr 2023 20:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681529416; x=1684121416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DYuiOUfZbNYoaOvaw4w44ADqt0elsTzyixCb90LMiNM=;
        b=PwChkDyHFiqCQAuJgi3SG8Hl2XFO7ygPzQDN+7mCh6sVabKy1wvaWsf7RcJXpn89ta
         BWztKvyNvUOQfSvVtnJdv6Z3+ve44wu2qSL9+PhkN7hZWElIDn8MkTIMzfdS0RLzOSTo
         YZ4kS8Tgg/hoVhVGTn6CZxle6g3rnSz3DDcKrBQYnYwn6ImsGhtAX8x+3xBj1FFd//rc
         PsqcswnLKcxMqtydMkaSm+X4EiCBt5AK4uM/P91cH0EShtrPwH70fbmpviVpPhy1ou3z
         Hy5VqrhvSPpruRRlV3bWP+fNL1z1PyL6/b0ddmYaBbnw/TZl+F+zADpXAu1svEk2xIB0
         qOWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681529416; x=1684121416;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DYuiOUfZbNYoaOvaw4w44ADqt0elsTzyixCb90LMiNM=;
        b=VW0mWPZsvXWdOpijyc1kJMBQm+Cute/1B0E3dmPqYcCqyLgJ3QYDExiW4rH7oa+U39
         M5w5TPBmsX2BjwvmJApQeZZnTYEPedGarUci9KB6DnWIPQbqGm3mX8drZoPCv2I6Mw71
         Jc/TH/fRd7J74VZCkc36b3jsJSzSyHUcBBY/NVS2lC89hxhDMEQfxgOYWRGK/Hi5iR3H
         b07CU6bVCF+ZqR6MEh1q3RSyW36HlA1hT1dIPqPLl4a3sCR40oitnIwI95GZWZr+3oJQ
         cjZK0dJtcOC/Ckxr5qMBNsd/MoUWI8Yi0dBIV+9+QUfAIilrX090yMifV8M89UU/1LI2
         hD7w==
X-Gm-Message-State: AAQBX9e41ag5T3VcyBaLCA7iB56h5mlULHMKfpDvzQixrQ91qYQ5gSJX
        8varHs9JzQejPd10q0qun5UymjxMV4oCug==
X-Google-Smtp-Source: AKy350YvmMOmwU3L7qtH+jQE0Sjc9WIWUjAwSq1iWGArEkm9M4ZIYn/t2izTlByhdJRlYB157DKFmA==
X-Received: by 2002:a17:902:ea03:b0:1a6:6c27:e8b8 with SMTP id s3-20020a170902ea0300b001a66c27e8b8mr5539088plg.59.1681529416497;
        Fri, 14 Apr 2023 20:30:16 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.3])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902c18500b001a5000ba26esm3689101pld.264.2023.04.14.20.30.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Apr 2023 20:30:16 -0700 (PDT)
From:   alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To:     seanjc@google.com
Cc:     alexjlzheng@gmail.com, alexjlzheng@tencent.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, tglx@linutronix.de, x86@kernel.org
Subject: Re: [PATCH v2] KVM: x86: Fix poll command
Date:   Sat, 15 Apr 2023 11:30:12 +0800
Message-Id: <20230415033012.3826437-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <ZDmSWIEOTYo3qHf7@google.com>
References: <ZDmSWIEOTYo3qHf7@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 14 Apr 2023, Sean Christopherson <seanjc@google.com> wrote:
> On Thu, Apr 13, 2023, alexjlzheng@gmail.com wrote:
> > From: Jinliang Zheng <alexjlzheng@tencent.com>
> > 
> > According to the hardware manual, when the Poll command is issued, the
> 
> Please add "8259", i.e. "According to the 8259 hardware manual".

Ok, I will pay attention next time.

> 
> > byte returned by the I/O read is 1 in Bit 7 when there is an interrupt,
> > and the highest priority binary code in Bits 2:0. The current pic
> > simulation code is not implemented strictly according to the above
> > expression.
> > 
> > Fix the implementation of pic_poll_read():
> > 1. Set Bit 7 when there is an interrupt
> > 2. Return 0 when there is no interrupt
> 
> I don't think #2 is justified.  The spec says:
> 
>   The interrupt requests are ordered in priority from 0 through 7 (0 highest).

This is only true when don't use rotation for priority or just reset the 8259a.
It's prossible to change priorities, i.e. Specific Rotation Mode or Automatic
Rotation Mode.

> 
> I.e. the current code enumerates the _lowest_ priority when there is no interrupt,
> which seems more correct than reporting the highest priority possible.

The practice and interpretation of returning to the lowest priority interrupt
when there are no active interrupts in the PIC doesn't seem reasonable, as far as I
understand. For #2, in my opinion, the correct interpretation of the current code
may be that a spurious interrupt is returned(IRQ 7 is used for that according to
the 8259 hardware manual).

For #2, the main purpose of returning 0 is to set Bit 7 of the return value to 0
to indicate that there is no interrupt.

Thank you very much.
Jinliang Zheng
