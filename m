Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 422286E5B15
	for <lists+kvm@lfdr.de>; Tue, 18 Apr 2023 09:59:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231250AbjDRH7c (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 Apr 2023 03:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230327AbjDRH7a (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 Apr 2023 03:59:30 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EC94448C;
        Tue, 18 Apr 2023 00:59:29 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-63b4960b015so1573354b3a.3;
        Tue, 18 Apr 2023 00:59:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681804769; x=1684396769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QDfon1gvE7DljOrP9PcEY/wSYyOf+N0g48rT8yKE6XQ=;
        b=F67g6HzGDMW1BQVjjJN+sKIj0bnh80m2DCcVyl0iEF0kj421fPANM7/ox1F/uH0xzo
         aHHZCAK/KgZLAjXJ9OW1MDwPsFWlBgsDFaNmyxQ7DCT1kr3s4eujLihoaqv8LpWzGNOD
         fDkxOCXrjlnxtci+q3WaxlUnN4xDSuUSK2ix5YqcB5hW7Fjtn3NqEk/9vZgcWI6mYPpw
         +XFQbo0179MXOrfjud+45UagLBG5KN/PmoUlvdzC0SeLo5JrmfyREoUr68Q61q7wxwvW
         67sDC9U3GOFSWE7hCKXuwJmDR8PmrJ/9Z7iUGBwCJuq4WB93r1kjtJGCtGiswswP/aH6
         /Ilw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681804769; x=1684396769;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QDfon1gvE7DljOrP9PcEY/wSYyOf+N0g48rT8yKE6XQ=;
        b=GOeW3McCwuS9A1tB1FrtcV5oVsBn/xwdZjChQu7YRpm6exUGNYukyHy3os1OXyqy6e
         y6JFSRK37g0Jde0CQ1qspNmjPYsVhu/BX1vKOzJL3TXjPiYUeIwAvuw6YJarBAqIdZLQ
         qBli4CQjY2FhwyopbswcTaN3whD5nu+Akjq1YxwdI1pCpNb5sKw4HfxfkQlAYPPzv6mm
         a2zy42L6V8zh+yP0n2lqB+GgdOA3sBhrZ13xKvPezaY5mlqCzWgCWYm1s8Wy+lFbOixZ
         yhGUkkggz6jM3mBoVL5Q7GZeg6BMHl1Q2Vq3GA5FkTeMydFITW4cYHFM+lQK1B/Xm4MN
         1Lww==
X-Gm-Message-State: AAQBX9cj6rpYOElUJsBB3Q5+HhDc3yPNZJ6zGpcjyHTom4zk0M0j7IAn
        aWJpd6B3xScYc/oKPPr6E6yWi6isBelvFg==
X-Google-Smtp-Source: AKy350by4NJsNnk65HQe14xnYwaFxrcyt/YD1dpvTfXLPiQ8LlMsIl4Tofq96QaRitZW6I0tPsyaDw==
X-Received: by 2002:a17:902:c106:b0:1a6:cb66:681f with SMTP id 6-20020a170902c10600b001a6cb66681fmr1140670pli.46.1681804768891;
        Tue, 18 Apr 2023 00:59:28 -0700 (PDT)
Received: from localhost.localdomain ([43.132.141.9])
        by smtp.gmail.com with ESMTPSA id jl4-20020a170903134400b001a52abb3be3sm8969480plb.201.2023.04.18.00.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 00:59:28 -0700 (PDT)
From:   alexjlzheng@gmail.com
X-Google-Original-From: alexjlzheng@tencent.com
To:     seanjc@google.com
Cc:     alexjlzheng@gmail.com, alexjlzheng@tencent.com, bp@alien8.de,
        dave.hansen@linux.intel.com, hpa@zytor.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        pbonzini@redhat.com, tglx@linutronix.de, x86@kernel.org
Subject: Re: [PATCH v2] KVM: x86: Fix poll command
Date:   Tue, 18 Apr 2023 15:59:23 +0800
Message-Id: <20230418075923.752113-1-alexjlzheng@tencent.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <ZD15KFZO9J33Eodj@google.com>
References: <ZD15KFZO9J33Eodj@google.com>
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

On Mon, 17 Apr 2023, Sean Christopherson <seanjc@google.com> wrote:
> On Sat, Apr 15, 2023, alexjlzheng@gmail.com wrote:
> > On Fri, 14 Apr 2023, Sean Christopherson <seanjc@google.com> wrote:
> > > On Thu, Apr 13, 2023, alexjlzheng@gmail.com wrote:
> > > > Fix the implementation of pic_poll_read():
> > > > 1. Set Bit 7 when there is an interrupt
> > > > 2. Return 0 when there is no interrupt
> > > 
> > > I don't think #2 is justified.  The spec says:
> > > 
> > >   The interrupt requests are ordered in priority from 0 through 7 (0 highest).
> > 
> > This is only true when don't use rotation for priority or just reset the 8259a.
> > It's prossible to change priorities, i.e. Specific Rotation Mode or Automatic
> > Rotation Mode.
> > 
> > > 
> > > I.e. the current code enumerates the _lowest_ priority when there is no interrupt,
> > > which seems more correct than reporting the highest priority possible.
> > 
> > The practice and interpretation of returning to the lowest priority interrupt
> > when there are no active interrupts in the PIC doesn't seem reasonable, as far as I
> > understand. For #2, in my opinion, the correct interpretation of the current code
> > may be that a spurious interrupt is returned(IRQ 7 is used for that according to
> > the 8259 hardware manual).
> > 
> > For #2, the main purpose of returning 0 is to set Bit 7 of the return value to 0
> > to indicate that there is no interrupt.
> 
> Is there an actual real world chunk of guest code that is broken by KVM's behavior
> for the "no interrupt" case?  Because if not, my strong preference is to leave the
> code as-is.
> 
> I have no objection to setting bit 7 when there is an interrupt, as that behavior
> is explicitly called out and KVM is clearly in the wrong.

Very happy that we have reached a consensus on #1.

> 
> But for the "no interrupt" case, there are a lot of "mays" and "seems" in both of
> our responses, i.e. it's not obvious that the current code is outright wrong, nor
> that it is correct either.  Given the lack of clarity, unless there's a guest that's
> actually broken by KVM's current implementation, I see no benefit to changing KVM's
> behavior, only the potential for breaking existing KVM guests.

For #2, neither returning 0 nor 7 will affect the behavior of interrupt handling in
the guest os. Because their Bit 7 are all 0, the guest os will interpret them as no
interrupt. However, keeping it as it is (return 7) will reduce the readability of
the pic_poll_read() code. When developers compare the code in kvm_pic_read_irq(),
they may think that what is returned in #2 is a spurious interrupt, but this is not.

> 
> And if the "no interrupt" case really does need to be fixed, please split it to
> a separate patch.

For the reasons above, I suggest fix #2. I will split it to a separate patch.

Thank you.
Jinliang Zheng
