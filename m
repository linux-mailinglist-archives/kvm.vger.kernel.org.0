Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482A7544E31
	for <lists+kvm@lfdr.de>; Thu,  9 Jun 2022 15:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245190AbiFIN4H (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 9 Jun 2022 09:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245507AbiFINzy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 9 Jun 2022 09:55:54 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8AB83527E
        for <kvm@vger.kernel.org>; Thu,  9 Jun 2022 06:55:51 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id e66so21875983pgc.8
        for <kvm@vger.kernel.org>; Thu, 09 Jun 2022 06:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2tLHzK+mawqr5s4YQ6aG7zolZuEOi6xg/YnpIdOHgKA=;
        b=NyQLoPCJ3Fw1Rd/RGxC+T32bhwep+nu9XPymI+sdFXniE5ncki+AyZjF1fI9FAvhg4
         Sd5BckuKevSoBcFbK6aZaFh8Kzat3G+uSAqRhBR4WBWpOOcVKlaExzWaHMw367fik5B9
         3QbcbwmyQOcwBpBwlGFrgxkQD4/1mx7ahCEJDokNSmGRdu6VIgTBZXbkPU8DcwkwnDT9
         qZudTLrtNMJP2US4cdNk6i+6HSIexRMbVZADyrgdK3UyFHn7roMgdruLGog8dPIjB/9u
         LSbl7vBuXu11RixFHrtp9Q82e7uJJt36zylh1BLV6lJuO5LLowub7Yiy0TwWHwrAbVPs
         188A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=2tLHzK+mawqr5s4YQ6aG7zolZuEOi6xg/YnpIdOHgKA=;
        b=hn9TpKVaCKso8Yjo34cye9FOvDxFbGX1viBehTLWjYhqIjUf7IOmWMhwvcHmxHQnIn
         FF4U1oxaH5fqpWm/swKa9rpEUCPCD696wePcxL+2lw1ucVqjoS5MNAOgbNFW2mvuuZNc
         ZESsdo4siKUnvc8vuU2hVK9lXqHHxtp3OcnC2zQNUxUZ2A1Ss73ly3IRFs8BKCUz9Xf9
         D4l6D7Qf8iprxRDT9aPgio3+DNTVYGWsE250Rm4evJ7kkGZRGuuSaK01o2Rmqs1uR1N+
         aVcBY8PjC5Qkimy2KkFFX4UAP4QVloX8s9uNdDz24g9mKELguD86QNrzYJSqfJGlBUlq
         /jAw==
X-Gm-Message-State: AOAM5301Gl2VjaL/SS4hsauga0zsq+i6mTectIpXQXoR51BsTnw707nM
        yKkEZkqxTwNn26QaJkJQ+PBhjg==
X-Google-Smtp-Source: ABdhPJw3Ip8vO/1+HSILbK6hPsf2Tnb1VWLRa9LQz5MYHsS2lwxwBEZCQ0c7Omj0EJ7aXxIunxnCsQ==
X-Received: by 2002:a63:40c3:0:b0:3fd:12b8:3207 with SMTP id n186-20020a6340c3000000b003fd12b83207mr30674164pga.57.1654782951047;
        Thu, 09 Jun 2022 06:55:51 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id f10-20020a17090ace0a00b001e31803540fsm16034735pju.6.2022.06.09.06.55.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jun 2022 06:55:50 -0700 (PDT)
Date:   Thu, 9 Jun 2022 13:55:46 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Yuan Yao <yuan.yao@linux.intel.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] KVM: selftests: Add MONITOR/MWAIT quirk test
Message-ID: <YqH74glDW88oZBzi@google.com>
References: <20220608224516.3788274-1-seanjc@google.com>
 <20220608224516.3788274-6-seanjc@google.com>
 <20220609063720.wf4famdgoucbglnq@yy-desk-7060>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220609063720.wf4famdgoucbglnq@yy-desk-7060>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, Jun 09, 2022, Yuan Yao wrote:
> On Wed, Jun 08, 2022 at 10:45:16PM +0000, Sean Christopherson wrote:
> > +static void guest_monitor_wait(int testcase)
> > +{
> > +	/*
> > +	 * If both MWAIT and its quirk are disabled, MONITOR/MWAIT should #UD,
> > +	 * in all other scenarios KVM should emulate them as nops.
> > +	 */
> > +	bool fault_wanted = (testcase & MWAIT_QUIRK_DISABLED) &&
> > +			    (testcase & MWAIT_DISABLED);
> > +	u8 vector;
> > +
> > +	GUEST_SYNC(testcase);
> > +
> > +	vector = kvm_asm_safe("monitor");
> > +	if (fault_wanted)
> > +		GUEST_ASSERT_2(vector == UD_VECTOR, testcase, vector);
> > +	else
> > +		GUEST_ASSERT_2(!vector, testcase, vector);
> > +
> > +	vector = kvm_asm_safe("monitor");
> 
> emmm... should one of the "monitor" be "mwait" ?

/facepalm

Thanks for catching my copy+paste fail!
