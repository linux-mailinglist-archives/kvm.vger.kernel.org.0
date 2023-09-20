Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46FDB7A8275
	for <lists+kvm@lfdr.de>; Wed, 20 Sep 2023 14:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236310AbjITM7X (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 20 Sep 2023 08:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236047AbjITM7W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 20 Sep 2023 08:59:22 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECFDEAB
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 05:59:13 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d84acda47aeso3911397276.3
        for <kvm@vger.kernel.org>; Wed, 20 Sep 2023 05:59:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695214753; x=1695819553; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y3wmPAnEgBxhZRH8t7r1kcgo1IpRf4a8FQcxFi6+YZA=;
        b=fnjgcqLTWFktXluoONga5YgCL8op3q4UJJQnCvF6USU4WuEpLk+JEyHpYgx7CKM5cD
         /dywMcVbGE4dE1dJCu40VdhlM/yMtZTdT8vNM8MAoa4jQyxOM6bQlQ4ge6DDxSR+g0DP
         5z8s91T7+JyFnO/UGBy1jecr+8zrY+Yj77PrtfiW6Q8IMTAuKbk8wOzisZngYCg8f3/r
         F+BDcBUJIjbEFM2U9fSdP4MQbL6G4YD5olU7HbsvsC9F7js9tsHu7ICkyKWDQoIsazEr
         QtxYnzDlrc8oPv6ucdP5PZ1Yq6hFczOMHDwYn7tRpZwIa+saAeY1Ir2Nq6Ia2XdvNyeE
         Uldg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695214753; x=1695819553;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Y3wmPAnEgBxhZRH8t7r1kcgo1IpRf4a8FQcxFi6+YZA=;
        b=wcWL8eVd6NK1Wq2c+HLNbXuU9lWvSX3p3AAINtTgWIh1ASWWNC7yZaAjdgGWh8DJCe
         gYAMyk9210OkfYs7f8W3JZM0VPKbxxaH9pQfh0H7od5bEwpmsJ0OWMzDz1pe55vpKRr/
         feaw6fZsNnQBouE0oeYfPoKzzGsDaTiXaU/enJcSo4NwIzs5j7yU5Ud7asN1F3+M0+vM
         P6Tp3Fecw8jTIYDXtRHxj6mzCh2qFDuNDD5XsU2rwEu239eq8XD0b76noH8GC5SDY6lZ
         Qw7dzw0iECwIicHpZ04L1E8fPy5Nu0x+0fbnY0yDb5/zaghcDitXr7yZXZaPONtFqnnX
         G3Kg==
X-Gm-Message-State: AOJu0Yxy8BJKLjQxSbcPU92lnUF+h+b+9APSKsp3zTqeqvmbv1+/OS4e
        QqsAZmtt5Sb5NZxgflrGo8uzgBigDmU=
X-Google-Smtp-Source: AGHT+IGOqqxtlFukUUfzBK6fHUUKzOQyLu4WD5tAqIeUWcLlS+2TJtNtJ4x7MKTmSURN75SthjwkSR2/nEg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6902:100c:b0:d40:932e:f7b1 with SMTP id
 w12-20020a056902100c00b00d40932ef7b1mr45097ybt.7.1695214753193; Wed, 20 Sep
 2023 05:59:13 -0700 (PDT)
Date:   Wed, 20 Sep 2023 12:59:11 +0000
In-Reply-To: <SA1PR11MB5923CE0CA793FF8B63DFDAEBBFF9A@SA1PR11MB5923.namprd11.prod.outlook.com>
Mime-Version: 1.0
References: <20230919234951.3163581-1-seanjc@google.com> <SA1PR11MB5923CE0CA793FF8B63DFDAEBBFF9A@SA1PR11MB5923.namprd11.prod.outlook.com>
Message-ID: <ZQrsdOTPtSEhXpFT@google.com>
Subject: Re: [ANNOUNCE] PUCK Agenda - 2023.09.20 - No Topic (Office Hours)
From:   Sean Christopherson <seanjc@google.com>
To:     Jason Chen <jason.cj.chen@intel.com>
Cc:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Sep 20, 2023, Chen, Jason CJ wrote:
> Hi, Sean,
> 
> Do you think we can have a quick sync about the re-assess for pKVM on x86?

Yes, any topic is fair game.
