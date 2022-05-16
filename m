Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3775F5292AE
	for <lists+kvm@lfdr.de>; Mon, 16 May 2022 23:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349431AbiEPVM4 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 16 May 2022 17:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350013AbiEPVMF (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 16 May 2022 17:12:05 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5295DD
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 14:01:05 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id a11so15137497pff.1
        for <kvm@vger.kernel.org>; Mon, 16 May 2022 14:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=i4dTskgxtfcBAryqUx+BQbUoqgYDRlBvic8nbKAjapY=;
        b=CiSxYrfpRKmrKuUKG99awbYY6DCxwS6MYs8TH8iRudLtn1qdn9ciNU3tYMNu6O6ANW
         J+2hg/sCe0SCGtDlshLbJWr7fPj686lsSLWcss1UZRrw+JJmwqBX1tonqQv2w7dL8S/a
         nRBuaEAf90CwKbdP1caXOcp+1zP0slfeps3EYEt1OgA2dVaUme3oWLCO1pga9URDinWj
         F6NaTuA6RPUpKtZn33JwgC37Lu61CQUmeQynf9rul5vj/59K4qX6c5J2c84/HUEf6BPv
         35PnpqUO76xSjWz29ZAbrjFkH1DVSEHeBp/3jUvQrTZfEidt8sflsbwzspRq4VR2cgz+
         Vasw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=i4dTskgxtfcBAryqUx+BQbUoqgYDRlBvic8nbKAjapY=;
        b=ODLKclXg2++62CoSZAsMZFI/Z4OSzQlM02d4/E3XILrFoP5Nd+aAeucKcmGtwbeYsf
         X+nxW5yMMkRGeRKovOE8Zodd57GoXTQ9PGPpSYrU0C0gsB0zPy4JPZ+FLpr7tY5nyO6q
         n8dnommThgVz0/LfbN2tkMNgdJkzbUqywNUZsJ6DY9XD2uzJSzQXIJyuIb4zVpTF9wT4
         aAMkDIy4wjOZq/pCNBeP6vL6BVSkq3bBL0tv8czAM7uUMLPUhsdy0j7uyE/qD0UJ66nQ
         RUmKBiMdt3PCB+F0nL+lp+Y7/danzOboSILVFHze/LGCQZqrsGSiTOtrnoPTTSJhw/yk
         tFJg==
X-Gm-Message-State: AOAM533EhLMLl49Vexsb/dPDFEawDBI1eQNjcpPHFeG3ZsZPvXEJnQPG
        bO62MNeE4n2MWixWnZDWxCH1eQ==
X-Google-Smtp-Source: ABdhPJzafGy7hPM1sEOI3aFMgMMCX7S92ofoaeSmRK7VKB1q7BUZH8Ok/90Hluz49PLCQv05oaj2RQ==
X-Received: by 2002:a63:f046:0:b0:3c6:a37b:1613 with SMTP id s6-20020a63f046000000b003c6a37b1613mr17037698pgj.168.1652734865113;
        Mon, 16 May 2022 14:01:05 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id q16-20020a170902dad000b0015e8d4eb295sm7871538plx.223.2022.05.16.14.01.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 14:01:04 -0700 (PDT)
Date:   Mon, 16 May 2022 21:01:01 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Oliver Upton <oupton@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        kvmarm@vger.kernel.org
Subject: Re: [PATCH 2/5] KVM: Shove vcpu stats_id init into
 kvm_vcpu_create_debugfs()
Message-ID: <YoK7jfvi1RB/w1B5@google.com>
References: <20220415201542.1496582-1-oupton@google.com>
 <20220415201542.1496582-3-oupton@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415201542.1496582-3-oupton@google.com>
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

On Fri, Apr 15, 2022, Oliver Upton wrote:
> Again, the stats_id is only ever used by the stats code; put it where it
> belongs with the rest of the stats initialization.

Heh, again, no?  Ah, but here you've conflated debugfs and stats in the changelog.
They are two different things.  And most critically, stats is not dependent on debugfs.
