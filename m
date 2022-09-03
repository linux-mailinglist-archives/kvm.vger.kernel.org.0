Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3D75AC1C2
	for <lists+kvm@lfdr.de>; Sun,  4 Sep 2022 01:50:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiICXuX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sat, 3 Sep 2022 19:50:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiICXuV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sat, 3 Sep 2022 19:50:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D743AB3B
        for <kvm@vger.kernel.org>; Sat,  3 Sep 2022 16:50:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 20550CE0B65
        for <kvm@vger.kernel.org>; Sat,  3 Sep 2022 23:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667B3C433D6;
        Sat,  3 Sep 2022 23:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662249015;
        bh=L906l7BdsjawLcpcLonOEY2+hGRW24utfqRTi+zgV/8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PKDBxyZ7EnD6Y8zisHIwYhevfmPaTI8l8A26TOII1aMUEDl5+BQBp9AM/OjNiiozt
         UDrQG5fpK7iX9M8+YpAImI7KbLrL1TdBuXTfd46wKA77LaUGW/iYKZI1Q8x+iol8jS
         xpQfEg71rlGSxmslaeEDv0400Qggp55Mh7wgsq5HzIVlhCEmfryOnhArHRCTTdw3ks
         7MxOI0TGWzDihx4fhTdAeblbZuLvZZoX71l1gaAFqy6qTUANYSalHQFBsTOtOuNLb6
         E47FJe4sPma1wYL0rdavQsy8b1K+jApny8zN4zRzqU0aMnXXtQwGXFdH5sNG6zzzSD
         3eY0RaAT56LIg==
Date:   Sat, 3 Sep 2022 16:50:13 -0700
From:   Josh Poimboeuf <jpoimboe@kernel.org>
To:     Jim Mattson <jmattson@google.com>
Cc:     kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        "Moger, Babu" <Babu.Moger@amd.com>
Subject: Re: Guest IA32_SPEC_CTRL on AMD hosts without X86_FEATURE_V_SPEC_CTRL
Message-ID: <20220903235013.xy275dp7zy2gkocv@treble>
References: <CALMp9eRkuPPtkv7LadDDMT6DuKhvscJX0Fjyf2h05ijoxkYaoQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALMp9eRkuPPtkv7LadDDMT6DuKhvscJX0Fjyf2h05ijoxkYaoQ@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Sep 02, 2022 at 04:53:35PM -0700, Jim Mattson wrote:
> On the Intel side, restoration of the guest's IA32_SPEC_CTRL is done
> as late as possible, with the comment:
> 
> * IMPORTANT: To avoid RSB underflow attacks and any other nastiness,
> * there must not be any returns or indirect branches between this code
> * and vmentry.
> 
> In light of CVE-2022-23825 ("Branch Type Confusion"), don't we also
> need to avoid returns or indirect branches between the wrmsr and
> VM-entry on AMD hosts without X86_FEATURE_V_SPEC_CTRL?

I don't think so, because for AMD we don't use the SPEC_CTRL mitigations
like Intel does.  i.e., no IBRS/eIBRS.

The AMD rethunk mitigation protects against retbleed regardless [*] of
the value of SPEC_CTRL.

[*] Not 100% true - if STIBP gets disabled by the guest, there's a small
    window of opportunity where the SMT sibling can help force a
    retbleed attack on a RET between the MSR write and the vmrun.  But
    that's really unrealistic IMO.

-- 
Josh
