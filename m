Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B490B4D2313
	for <lists+kvm@lfdr.de>; Tue,  8 Mar 2022 22:09:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350339AbiCHVKK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 8 Mar 2022 16:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350336AbiCHVKH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 8 Mar 2022 16:10:07 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2701649CB1
        for <kvm@vger.kernel.org>; Tue,  8 Mar 2022 13:09:10 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id g19so439558pfc.9
        for <kvm@vger.kernel.org>; Tue, 08 Mar 2022 13:09:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EZ13Ad+Zn+Xj7/UE9QdPV67yzSek7jFKj0Lb1KNVlJ8=;
        b=HCn8+hhS8kx1HBgNpxqU/16tZci1llASe7ZDRD+FqpXltxdkBryVvtSCwkhCU31/oZ
         O8wIXN4mxWadoQcTYvsW/6mR5tuHM0uF+/Mb1gSUa1HKXGQ0fkcz9Q56nTdxch/vNyfm
         pZPKvQ/FLqfPCC3AlDhbhEjd5cpEx/oJgZHHp0l9O8xBn9C9UVi7Jva4y2bqRmrfBmAy
         Rq2tZshceNRXnUC5okVoaE+vDMnlJ1fv+gD/GPLamwOfdLljzudaJCbsZYzZyDJd7IR0
         LWiTzpwY52nA/RRIVODwtM3juWIOyBqW+FnGMXPXnhIdEnZepVjgyQPu/bOsj0HUdJgP
         IqSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EZ13Ad+Zn+Xj7/UE9QdPV67yzSek7jFKj0Lb1KNVlJ8=;
        b=lV0LkECbCMMKgJvQN5LSlaPyQUSe/OdgwRisixwVmnZb6mgtLnLSGPwIvty+t6nUvJ
         8A+gpwJGZoi6yeeQCuRHgas2xG9zYFQa6Q+EnKJh9nZYx0dT7NUewd/wiCKZkKJ8p+hd
         UlRWAYJkFYeojzzQqrFMmep9AmXuZJxIru2Hhdu6YOgTjZWERTVxfEQ0eDa6eXrag+aN
         GCUk+e9fPV3f8BFTNhovHwpFFgNeHdyrsxx3P1TGI1ssyBt0PHhcQevpDiDprbdCH2ht
         EkTh/1TxSXl5JyZACjTHrEEReoktgHTKG8VCWpSs1UzjcdD2vvDP/9CBg37KncUyMiyV
         3Atw==
X-Gm-Message-State: AOAM533aeXFTumEbSU0YmTS/NtgQ/OOFVjtQFf4ERUuWrmrOl9I5cg/m
        qboq6v15NbOxuneT5iVUyJAW2A==
X-Google-Smtp-Source: ABdhPJyxBjhyl4QE3OFAzM2+v5w8xr8npBIZ/tPioD64MIsO8C4MDpqctA/ZreGVU7ij+l/N/IfqTA==
X-Received: by 2002:a05:6a00:1584:b0:4f7:4647:6fdd with SMTP id u4-20020a056a00158400b004f746476fddmr962674pfk.84.1646773749482;
        Tue, 08 Mar 2022 13:09:09 -0800 (PST)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id kk5-20020a17090b4a0500b001bf527073besm4193356pjb.10.2022.03.08.13.09.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 13:09:08 -0800 (PST)
Date:   Tue, 8 Mar 2022 21:09:05 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Marc Zyngier <Marc.Zyngier@arm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH v4 30/30] KVM: selftests: Add test to populate a VM with
 the max possible guest mem
Message-ID: <YifF8QrNxDX4qU4J@google.com>
References: <20220303193842.370645-1-pbonzini@redhat.com>
 <20220303193842.370645-31-pbonzini@redhat.com>
 <63f4a488-87f1-097f-95d5-f85e46786740@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63f4a488-87f1-097f-95d5-f85e46786740@redhat.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Mar 08, 2022, Paolo Bonzini wrote:
> On 3/3/22 20:38, Paolo Bonzini wrote:
> > On x86, perform two passes with a MMU context reset between each pass to
> > coerce KVM into dropping all references to the MMU root, e.g. to emulate
> > a vCPU dropping the last reference.  Perform both passes and all
> > rendezvous on all architectures in the hope that arm64 and s390x can gain
> > similar shenanigans in the future.
> 
> Did you actually test aarch64 (not even asking about s390 :))?  For now
> let's only add it for x86.

Nope, don't you read my cover letters?  :-D

  The selftest at the end allows populating a guest with the max amount of
  memory allowed by the underlying architecture.  The most I've tested is
  ~64tb (MAXPHYADDR=46) as I don't have easy access to a system with
  MAXPHYADDR=52.  The selftest compiles on arm64 and s390x, but otherwise
  hasn't been tested outside of x86-64.  It will hopefully do something
  useful as is, but there's a non-zero chance it won't get past init with
  a high max memory.  Running on x86 without the TDP MMU is comically slow.


> > +			TEST_ASSERT(nr_vcpus, "#DE");
> 
> srsly? :)

LOL, yes.  IIRC I added that because I screwed up computing nr_vcpus and my
test did nothing useful :-)
