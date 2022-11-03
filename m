Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B33617349
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 01:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbiKCASj (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 2 Nov 2022 20:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiKCASh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 2 Nov 2022 20:18:37 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD5F65D5
        for <kvm@vger.kernel.org>; Wed,  2 Nov 2022 17:18:37 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id y13so174683pfp.7
        for <kvm@vger.kernel.org>; Wed, 02 Nov 2022 17:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bCQtxRI6S1jaqGbru2XthNpEAYm8+HAaLC9FoyL3iBk=;
        b=ddOVPbUD4GyJ/5XxPS/mySuFr/TZqCDiPVo9GH5CMKvrTD9xTT6+UO4zrCBFKU6bEc
         h7iFaz1TwgLyS1lmNKCKyVvbfdE94I1MqYrGDZWD5xWse9iRG12oTRrFTSlnK7t+GhU6
         zsh6zFAlY0V5ufRSJ9y427zXuXwsiNHsdAcp7mSBeiJ+eAublCFO2nYPLvbP9Ci4wLaR
         Kjr7sPZUB8dgqiJ9HRV1V8T013QNdf4icnegHPrhrCHIN6xAmB7ELa4AiEcQU/2cOeGv
         xMbntHQBIPIAMM7tiJ7/z3GmESEUn3GTQ1PVUOy/jlzkf6m7c4vCDZRacouaktiLfoiQ
         8+JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bCQtxRI6S1jaqGbru2XthNpEAYm8+HAaLC9FoyL3iBk=;
        b=pgFshyOecIW8bmE9k8v7hxiG0p0d1bwskhefsbIC47aRABHH+V1xrNwF/8+0tOe0yN
         1+OG9tHpm3sic2e2PIvODjcYPz7wLpNnPHUrbxIJMgpaymvlWus6g3jKb4PMSNZyv3Mq
         owY+FBSNX1dx/gpVXL8luPar7Hw4mKBwycSqomCsX04YoVjUP2BduxCLggBJ9D+jMlAF
         KavRZq0jDnJz6gS8zAPuiXoM/Q7qKXKgaAbylQXf6KWavLfU4/e5wqDa/MCqnlv5cdeg
         IvyDcOzRK6GYlqnoRzaL0JVz0ttWf5iRMaghFnlVuCfRBpHi66RIXbVRHLXxKBDbuh4o
         5lVg==
X-Gm-Message-State: ACrzQf3xNU+Tz32nvnCrds7DSSu/tiXC0NB3TMiENY8VdMf0oSZoCeXQ
        C8psp+sq0MmZ4nYd43GQxDLh/Q==
X-Google-Smtp-Source: AMsMyM7/LM4Pq2WKGmQ3w010goQWJD+Neqa+YUNygZhB9ScSJlfXq7noZEoeP9p4lqaKOsr0L4qEQw==
X-Received: by 2002:a63:6905:0:b0:43c:d4:eef4 with SMTP id e5-20020a636905000000b0043c00d4eef4mr23204378pgc.126.1667434716555;
        Wed, 02 Nov 2022 17:18:36 -0700 (PDT)
Received: from google.com (7.104.168.34.bc.googleusercontent.com. [34.168.104.7])
        by smtp.gmail.com with ESMTPSA id 4-20020a621404000000b0056c704abca7sm9011808pfu.220.2022.11.02.17.18.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Nov 2022 17:18:36 -0700 (PDT)
Date:   Thu, 3 Nov 2022 00:18:32 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Vipin Sharma <vipinsh@google.com>
Cc:     pbonzini@redhat.com, dmatlack@google.com, andrew.jones@linux.dev,
        wei.w.wang@intel.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/7] KVM: selftests: Add atoi_paranoid() to catch
 errors missed by atoi()
Message-ID: <Y2MI2EnjTiVDE0UB@google.com>
References: <20221102232737.1351745-1-vipinsh@google.com>
 <20221102232737.1351745-4-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102232737.1351745-4-vipinsh@google.com>
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

On Wed, Nov 02, 2022, Vipin Sharma wrote:
> atoi() doesn't detect errors. There is no way to know that a 0 return
> is correct conversion or due to an error.
> 
> Introduce atoi_paranoid() to detect errors and provide correct
> conversion. Replace all atoi() calls with atoi_paranoid().
> 
> Signed-off-by: Vipin Sharma <vipinsh@google.com>
> Suggested-by: David Matlack <dmatlack@google.com>
> Suggested-by: Sean Christopherson <seanjc@google.com>
> ---

Reviewed-by: Sean Christopherson <seanjc@google.com>
