Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE92636597
	for <lists+kvm@lfdr.de>; Wed, 23 Nov 2022 17:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239042AbiKWQUy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Nov 2022 11:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239048AbiKWQUt (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Nov 2022 11:20:49 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 204488F3F6
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 08:20:48 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id b1-20020a17090a7ac100b00213fde52d49so2268956pjl.3
        for <kvm@vger.kernel.org>; Wed, 23 Nov 2022 08:20:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=biytTCPD12F4npEKT0DfXCiC4jXj2dN/DuTN/IJuM4s=;
        b=AF3yX36RbTt6w4YEqeeyFdeC+mAm6+7DlXNR5rnZVktMI8K6LdlLOZ6r6wn5ZFj+Tf
         lQjlmkDJPf4hsgvCsYB37Q4wWjng3xSdxWBgiqcJ/edqBZfWuAtpjFU9ImN5HhLWbYnd
         2RIhMM1aMliGLXZyB4bqFeL7TjrWxPVyvYhaKSOZbmhLU6m3U9IIzf0QYr0NS0QayBMr
         yYUvc/iHV1UhN1a/Lvy/RMDKFZz9yt0t+j2i83TNzA/8YogsvLzOJ1jiMNJnk0vElcPP
         UtIk4CJybUNrKl3EUJPbl3KTk9Wif7xwTAQhkeEn58zqTeq7pesgEdvT0lUf75PCyqe5
         +tHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=biytTCPD12F4npEKT0DfXCiC4jXj2dN/DuTN/IJuM4s=;
        b=AI/Lu0hmyB2kd5nyO+Mk/BYw9+to3CqJDnaseomJUqLrtYFotmVf9RXakyTsEcE4ga
         OpKyfwKjVqOvEm/w57JAkDKzF6vDC2X8SfquGZWJPWjZW4zEPy5LqD6LxTQffdA4E/Lu
         ewVUmVkhR8ppEZ1yFOqyGAkpJRgCqcW09xSEF2kTkpKmV7JZDShHFRNTRqgDe3MCxXc5
         ct923nQUMxZxv6VEhetzilrJuuSMTd5f0W4ZdksiG2LLZY+E5SkH0dLypfiLU2bRZ7cA
         RW0Vf/MdwWmRPLbZslOusuXCJDswE6ZNB++3Lx8ePGTdSUHyyXW2Rjq71Zg+NiC4MOuo
         RKCQ==
X-Gm-Message-State: ANoB5pnQgILHoy2/pzOLSILuQPPl7oLvH3pjKLWsnO3z7eetVOKaSwhR
        cL7tcjHP1JQiKgselGM/E4rpBA==
X-Google-Smtp-Source: AA0mqf4LMvmUvNu8vznYJ9wo0VaZW/vEVEFJ6RP2FuHSxjBL2AQ6kZF8XJvOOwNkqFIQHA99DQTkqQ==
X-Received: by 2002:a17:902:d711:b0:17f:52af:d035 with SMTP id w17-20020a170902d71100b0017f52afd035mr10178670ply.106.1669220447476;
        Wed, 23 Nov 2022 08:20:47 -0800 (PST)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id a22-20020a170902b59600b00177f25f8ab3sm14522037pls.89.2022.11.23.08.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 08:20:46 -0800 (PST)
Date:   Wed, 23 Nov 2022 16:20:43 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     "Huang, Kai" <kai.huang@intel.com>
Cc:     "peterz@infradead.org" <peterz@infradead.org>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "Luck, Tony" <tony.luck@intel.com>,
        "bagasdotme@gmail.com" <bagasdotme@gmail.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Chatre, Reinette" <reinette.chatre@intel.com>,
        "pbonzini@redhat.com" <pbonzini@redhat.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Yamahata, Isaku" <isaku.yamahata@intel.com>,
        "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>,
        "Shahar, Sagi" <sagis@google.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "Gao, Chao" <chao.gao@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "sathyanarayanan.kuppuswamy@linux.intel.com" 
        <sathyanarayanan.kuppuswamy@linux.intel.com>,
        "Huang, Ying" <ying.huang@intel.com>,
        "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH v7 06/20] x86/virt/tdx: Shut down TDX module in case of
 error
Message-ID: <Y35IW/PnbxinKHOL@google.com>
References: <cover.1668988357.git.kai.huang@intel.com>
 <48505089b645019a734d85c2c29f3c8ae2dbd6bd.1668988357.git.kai.huang@intel.com>
 <Y3ySxEr64HkUaEDq@hirez.programming.kicks-ass.net>
 <52b2be9b-defd-63ce-4cb2-96cd624a95a6@intel.com>
 <Y30fUS5/JClpBHVc@hirez.programming.kicks-ass.net>
 <b3938f3a-e4f8-675a-0c0e-4b4618019145@intel.com>
 <da7ae78c2d9fed125f160744af5be75f34b1b1d7.camel@intel.com>
 <791bf9a2-a079-3cd6-90a3-42dbb332a38c@intel.com>
 <9f1ea2639839305dd8b82694b3d8c697803f43a1.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9f1ea2639839305dd8b82694b3d8c697803f43a1.camel@intel.com>
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

On Wed, Nov 23, 2022, Huang, Kai wrote:
> On Tue, 2022-11-22 at 17:04 -0800, Dave Hansen wrote:
> > On 11/22/22 16:58, Huang, Kai wrote:
> > > On Tue, 2022-11-22 at 11:24 -0800, Dave Hansen wrote:
> > > > > I was expecting TDX to not get initialized until the first TDX using KVM
> > > > > instance is created. Am I wrong?
> > > > I went looking for it in this series to prove you wrong.  I failed.  😄
> > > > 
> > > > tdx_enable() is buried in here somewhere:
> > > > 
> > > > > https://lore.kernel.org/lkml/CAAhR5DFrwP+5K8MOxz5YK7jYShhaK4A+2h1Pi31U_9+Z+cz-0A@mail.gmail.com/T/
> > > > I don't have the patience to dig it out today, so I guess we'll have Kai
> > > > tell us.
> > > It will be done when KVM module is loaded, but not when the first TDX guest is
> > > created.
> > 
> > Why is it done that way?
> > 
> > Can it be changed to delay TDX initialization until the first TDX guest
> > needs to run?
> > 
> 
> Sean suggested.
> 
> Hi Sean, could you commenet?

Waiting until the first TDX guest is created would result in false advertising,
as KVM wouldn't know whether or not TDX is actually supported until that first
VM is created.  If we can guarantee that TDH.SYS.INIT will fail if and only if
there is a kernel bug, then I would be ok deferring the "enabling" until the
first VM is created.
