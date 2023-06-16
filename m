Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4854733890
	for <lists+kvm@lfdr.de>; Fri, 16 Jun 2023 20:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345417AbjFPS6C (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 16 Jun 2023 14:58:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345353AbjFPS54 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 16 Jun 2023 14:57:56 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CEEC3AAF
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 11:57:50 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-bcef239a9fbso4647158276.1
        for <kvm@vger.kernel.org>; Fri, 16 Jun 2023 11:57:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686941869; x=1689533869;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LhsPWwDQko0UkCkwLjPgQeFXArZxEN4mlCRcm66Is24=;
        b=x0T4t9pl2fO8xd/qYtr8kHdSzMeWn0PqLX/qmdTGIpV6Jl4d7BLCIkA60kLUiQ9412
         yrKAzorrRLj0x0l9T9ARMU0P1hN4hCnx8D4ASxIbCNMCDt6fgT4viTibVRYXH7IXC/ss
         UY5d0XhviLZ4VbuNyub89iG8OPO2OrYZDqNM9Yf6kGQ61x5XDAigOooppM368PVmJ4qn
         wu7orb0hcaPl2F3L0GgtxPKr8LK4mhT0R+EBZvzLFlJu/7xjyG074gxP4cqOemEoUmCO
         Zn1Dfzdyg3UFkcZkHtN4DTHRDx6TB7ytf9Xy+KQKhxkB6E0pwClIXd3dp56nFXdF+yEp
         CqtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686941869; x=1689533869;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=LhsPWwDQko0UkCkwLjPgQeFXArZxEN4mlCRcm66Is24=;
        b=fE+hAtqPAr/NPtrIFToDyrNcgC56nmZfPvDn2kaKZp79dFA4YRwxA5+x/txLtOChnD
         bGjinIrEyrJNZQWvkSJxfEoc5BHhhrTGeLj42D6TB30xR/SQEUN/q2UtdT6jZMaGNks5
         AEzTiBFL/2/es6YNEKjM4pmgrz2GgcrPQVajr5garkRG7qjidFr5/1AT7tWdakvBrHSA
         Nf+cn83xX6VBi9y/X7v5joVfvGRPTXrDbTjj+YJdnxUyfQ9k16cjknxt3L6dZecXe3Dr
         U9jrUzU0FGptX1aybfgOrBNMVhqM0jaEXjgnLu2ZyOlaDPBkH45JcIAxV/ewvlsHSOaG
         Y8Rw==
X-Gm-Message-State: AC+VfDz2rrqYLbqkC0iE0hJQCQZiBa/ju5gNJNn9udzXNjwszibRyZ/8
        MTeXkHhatRRr4DDN/9WWQFG7Xiai1yM=
X-Google-Smtp-Source: ACHHUZ6ulpCk+ICzHKZxc07/zRYVs7O1gpYF9E30HA2H+3KsaFB8ig+6dCjv16OmFlFWZU6AcSkpyETrnAA=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:1702:b0:bc7:f6af:8cfe with SMTP id
 by2-20020a056902170200b00bc7f6af8cfemr5309ybb.4.1686941869115; Fri, 16 Jun
 2023 11:57:49 -0700 (PDT)
Date:   Fri, 16 Jun 2023 11:57:47 -0700
In-Reply-To: <dfdf6d93-a68c-bb07-e59e-8d888dd6ebb6@intel.com>
Mime-Version: 1.0
References: <20230511040857.6094-1-weijiang.yang@intel.com>
 <20230511040857.6094-11-weijiang.yang@intel.com> <ZH73kDx6VCaBFiyh@chao-email>
 <21568052-eb0f-a8d6-5225-3b422e9470e9@intel.com> <ZIulniryqlj0hLnt@google.com>
 <dfdf6d93-a68c-bb07-e59e-8d888dd6ebb6@intel.com>
Message-ID: <ZIywqx6xTAMFyDPT@google.com>
Subject: Re: [PATCH v3 10/21] KVM:x86: Add #CP support in guest exception classification
From:   Sean Christopherson <seanjc@google.com>
To:     Weijiang Yang <weijiang.yang@intel.com>
Cc:     Chao Gao <chao.gao@intel.com>, pbonzini@redhat.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        peterz@infradead.org, rppt@kernel.org, binbin.wu@linux.intel.com,
        rick.p.edgecombe@intel.com, john.allen@amd.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, Jun 16, 2023, Weijiang Yang wrote:
>=20
> On 6/16/2023 7:58 AM, Sean Christopherson wrote:
> > On Thu, Jun 08, 2023, Weijiang Yang wrote:
> > > On 6/6/2023 5:08 PM, Chao Gao wrote:
> > > > On Thu, May 11, 2023 at 12:08:46AM -0400, Yang Weijiang wrote:
> > > > > Add handling for Control Protection (#CP) exceptions(vector 21).
> > > > > The new vector is introduced for Intel's Control-Flow Enforcement
> > > > > Technology (CET) relevant violation cases.
> > > > >=20
> > > > > Although #CP belongs contributory exception class, but the actual
> > > > > effect is conditional on CET being exposed to guest. If CET is no=
t
> > > > > available to guest, #CP falls back to non-contributory and doesn'=
t
> > > > > have an error code.
> > > > This sounds weird. is this the hardware behavior? If yes, could you
> > > > point us to where this behavior is documented?
> > > It's not SDM documented behavior.
> > The #CP behavior needs to be documented.  Please pester whoever you nee=
d to in
> > order to make that happen.
>=20
> Do you mean documentation for #CP as an generic exception or the behavior=
 in
> KVM as this patch shows?

As I pointed out two *years* ago, this entry in the SDM

  =E2=80=94 The field's deliver-error-code bit (bit 11) is 1 if each of the=
 following
    holds: (1) the interruption type is hardware exception; (2) bit 0
    (corresponding to CR0.PE) is set in the CR0 field in the guest-state ar=
ea;
    (3) IA32_VMX_BASIC[56] is read as 0 (see Appendix A.1); and (4) the vec=
tor
    indicates one of the following exceptions: #DF (vector 8), #TS (10),
    #NP (11), #SS (12), #GP (13), #PF (14), or #AC (17).

needs to read something like

  =E2=80=94 The field's deliver-error-code bit (bit 11) is 1 if each of the=
 following
    holds: (1) the interruption type is hardware exception; (2) bit 0
    (corresponding to CR0.PE) is set in the CR0 field in the guest-state ar=
ea;
    (3) IA32_VMX_BASIC[56] is read as 0 (see Appendix A.1); and (4) the vec=
tor
    indicates one of the following exceptions: #DF (vector 8), #TS (10),
    #NP (11), #SS (12), #GP (13), #PF (14), #AC (17), or #CP (21)[1]

    [1] #CP has an error code if and only if IA32_VMX_CR4_FIXED1 enumerates
        support for the 1-setting of CR4.CET.
