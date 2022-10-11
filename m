Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B62C55FBABC
	for <lists+kvm@lfdr.de>; Tue, 11 Oct 2022 20:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiJKStV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 11 Oct 2022 14:49:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiJKStN (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 11 Oct 2022 14:49:13 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980CE844F5
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 11:49:10 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id fw14so13270647pjb.3
        for <kvm@vger.kernel.org>; Tue, 11 Oct 2022 11:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jwkFDlz9tcdYO6bV+xcikvmI/CSEQsMZVRK8av7yruw=;
        b=aIMWuPDJXxRdN5Qs9xW4qL85/oHPC1MLzbpeHd4JkasLXAhLJzO5st9k+zAUK65L96
         +IekPrKDy3Sig96K6pXW2u/ZC5EXj9X3mqP/yNa+nFrDVBngj4Mg2GiWvxwFsSThe7eS
         ytM+xOwa7UA7aSkJ1V5NxCJQp+kmapZOP7hP4UC8GaUph6gSLAPn2L72+l18zKFS8tnd
         BU2czs7qvQKsv9/hZDihep+UL5R0T4e++gp95Xc3yp/jbvgbGu+qQ5oTX0WGDnuH6Md6
         8V8tVlFfhGk2dmiDlx8U75BJnIuDka4cYNgszHevxxRVcZlu6v6Klas37FDFx6Ppf99X
         58Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jwkFDlz9tcdYO6bV+xcikvmI/CSEQsMZVRK8av7yruw=;
        b=Cu/XmntGVcjf2khd1EyiY07iROOzew03eU0V79T/yQ7A1sMH20umXhJkaHUu73Ghjf
         spbgINujBpYIPjLYvURoL4qQnfxmJJqR8Y+egaOIM2VWMPp/Diz4SQzEiUXA29zDukvZ
         C7Ion2ax5Qg/aINjUConvU0Q363+A2hG8TFs1MfAPVeIAMvwh/IKTklJv1BasHOCKE53
         wSXxyFD2lD3wOKXVRsegurcO9qpZrFunnP9P6HwXNYal1r2ni/y4px9AfEXmPrSW4z2b
         oRwxFtfc8JisEzb8R1J/fff6ocKJ5h5rny4+FkIWgzKa+5pIQScccblsRepkWd/+ehA/
         cFJw==
X-Gm-Message-State: ACrzQf0kajYGrbz7bZMyqZezF2ldbXtDMF6kxHKoZTuvUKXIP/KPVING
        NmqRm2ABCyhIYB8fgXWBJbEyeQ==
X-Google-Smtp-Source: AMsMyM4ibOMlqXrZ3NXwGeb943rTcVgVAmEipZJLZ6ehVfrxhQFRRsHecETxCCh/ytaRdGx4tbay/w==
X-Received: by 2002:a17:90b:1c8b:b0:203:dcf1:128a with SMTP id oo11-20020a17090b1c8b00b00203dcf1128amr592532pjb.182.1665514149557;
        Tue, 11 Oct 2022 11:49:09 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id qe3-20020a17090b4f8300b001f22647cb56sm11286280pjb.27.2022.10.11.11.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Oct 2022 11:49:09 -0700 (PDT)
Date:   Tue, 11 Oct 2022 18:49:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com
Subject: Re: [PATCH 2/2] KVM: VMX: Execute IBPB on emulated VM-exit when
 guest has IBRS
Message-ID: <Y0W6oXTfH5bMVHxH@google.com>
References: <20220928235351.1668844-1-jmattson@google.com>
 <20220928235351.1668844-2-jmattson@google.com>
 <CALMp9eRRgw=SBMTY=LtBG6zPRt4Swk_0kW4NdeTS=zVeV+UbQg@mail.gmail.com>
 <Yz90B/mdrOLO2nyl@google.com>
 <CALMp9eROYwaB45YmH7NDukzzNvoJH3MAR9WvU2CkPen1eCwggA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALMp9eROYwaB45YmH7NDukzzNvoJH3MAR9WvU2CkPen1eCwggA@mail.gmail.com>
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

On Mon, Oct 10, 2022, Jim Mattson wrote:
> Should I send v2, or can this all be handled when applying?

Go ahead and send a v2, need to sort out who's doing what for KVM x86 this cycle,
i.e. Paolo might end up applying this.

All of your suggestions look good.
