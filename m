Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABD49607A3B
	for <lists+kvm@lfdr.de>; Fri, 21 Oct 2022 17:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbiJUPM2 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 21 Oct 2022 11:12:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230306AbiJUPMI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 21 Oct 2022 11:12:08 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 186E624A575
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 08:11:55 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id m14-20020a17090a3f8e00b00212dab39bcdso456906pjc.0
        for <kvm@vger.kernel.org>; Fri, 21 Oct 2022 08:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TDWBSKUOxk1MS8sahwUCxJrP6mn3rTa/DfYCPn2xgwU=;
        b=g4eEP/DRbVJVgWqeAPyN8MoeecoBADndcqppWSicvOBNBYBCCBOj4EqA7VBUWDQKSt
         9yUsOppgJj+T4TufXLCn7V/Ca/k3pnJ98LBDTQg7+UqxkBy7matNxHWrg9NG9bxWPQuQ
         aq7lkMN8E4hB5tHptzYF9O3Nd3AoIGY3zx82QSqI6JDMFB8KJLWypoe8XJwzT1bPLqLE
         xEzik0svP4D8fkWQjrM9hZGhejrYo8gU4MoFoqfmr12SfBlcwH5qeT03l1r/hMIURNQv
         tfhxmtqNWXjInb9KiIcUe0seQ28h/g9Jfvt32QBZgEpWHngKrI+OsgvhQVlk5Hd6Uifj
         R+9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TDWBSKUOxk1MS8sahwUCxJrP6mn3rTa/DfYCPn2xgwU=;
        b=gG9tBw7sM70ZWG6EmzEvrjqlsnflR4jdNtrLyznQicLN1OhKcUcVjwhTA7ZTLQlKYb
         MUR1CVIbXAsANU7SI9gYflK9o7IcpFXAb9zOVbTo2Y+PL0cJ5gtH4Lvkketrgg8hoBKS
         gsSTPOiqEadrfbYbSgh6gQFIquSpPLPpPV/Mr51doGM2D2zP2Px2MAilbgf/kGlVrcUN
         IHQa0t8Yo9JkqNzeRes7J9afoqLrJB2tsv5q+ToH1EplBkfTtt/g6nnWjgiS2zY+iZ4Z
         Q4vLupAWlmiIncei+YvEyUOAH5LRkZ41CEYPimDBxSWoj/oUuJTBXxX8sSefkPuKnfQ/
         mqrA==
X-Gm-Message-State: ACrzQf2MYRvONlMpsWKw79U+ChnWOYlIIsuSdKYpYZaX5UQtsswOWdcO
        nyTDpL+kCFfqLfm7Lo2p7lEeBA==
X-Google-Smtp-Source: AMsMyM4HpUL75SY4AAPrUy+NsP0ZdpoF7GL2na83jW2a/A4nStjNzADFs3WKvQooJLDqA6NTspY7JQ==
X-Received: by 2002:a17:90a:ab90:b0:210:27cb:e337 with SMTP id n16-20020a17090aab9000b0021027cbe337mr14747314pjq.139.1666365114945;
        Fri, 21 Oct 2022 08:11:54 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id u2-20020a170902e80200b00184360e5d68sm4068201plg.268.2022.10.21.08.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 08:11:54 -0700 (PDT)
Date:   Fri, 21 Oct 2022 15:11:50 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Fuad Tabba <tabba@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
        hpa@zytor.com, will@kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86/mmu: Release the pfn in handle_abnormal_pfn()
 error path
Message-ID: <Y1K2toQAAj90+ATK@google.com>
References: <20221021111932.3291560-1-tabba@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221021111932.3291560-1-tabba@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Oct 21, 2022, Fuad Tabba wrote:
> Currently in case of error it returns without releasing the pfn
> faulted in earlier.

handle_abnormal_pfn() returns something other than RET_PF_CONTINUE if and only if
there was no pfn to fault-in, i.e. it only handles error and no-slot pfns.
