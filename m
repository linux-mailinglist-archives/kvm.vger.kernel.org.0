Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 759D972319F
	for <lists+kvm@lfdr.de>; Mon,  5 Jun 2023 22:43:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233285AbjFEUnb (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Jun 2023 16:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232964AbjFEUn3 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Jun 2023 16:43:29 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721A5EC
        for <kvm@vger.kernel.org>; Mon,  5 Jun 2023 13:43:28 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-568960f4596so87616367b3.1
        for <kvm@vger.kernel.org>; Mon, 05 Jun 2023 13:43:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685997807; x=1688589807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ICeGZIs40frckeRMgP118BFqvwVxt76v5BvLpjWGtEE=;
        b=AGGvGj4kbhTcDK6teOtsJ8pOGUFJqw7a0bsRyQTqH9V7iS0KIHVI3hCKq1GKNhycjH
         jLTi/eOJlyUUO93XrauBBjK9eaX4lsqatX16BOBA1SKOzYtGZ5cOIeAel6Z8hqJ4vO9l
         FpnM7zWNKuhwVyY82qhwSiTuqJKVKudLtG7Ys3AaR4oGvNGjTnloIY8MXWqb2mT+Z4co
         p2oatktkP04Pdui5QjzMDLAZ0//7t/qSj/uNOyCwm/Rb0uxvNH3cp9oi5DWNCg3IH9k8
         fwfVwNPLn4jhIs/2YnnLKaVDnDqmNudJ9vi2ZznkBxgA3fM3F8EpO6A09z2NiLev/G1D
         rXQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685997807; x=1688589807;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ICeGZIs40frckeRMgP118BFqvwVxt76v5BvLpjWGtEE=;
        b=UumU3AiwVrI6Vkqzm6jUB5a/DqPi/mSXsjj+haUkPK0q8Eb1Ray9YfOKqXD4Ne8TvL
         8UghVU3Qw19oNcMd5M6xKJhaSP9OTbsYSo2f+YwecUrAMtOrYhkhvgJzyzrU3snte3+E
         npek1Qrds1YkneeDZ3vKf+URlXrjVON7Fv4tdqYzTtWDzBbu3x1IJ5IVbAixkAJYY+5S
         +1dd1YQpa4uEVbajf/XLzfuSox7j4i7CLXmv/OMxP9ZpZw05OdUoLdjevr+jbmR+iFJa
         fJUhxssOoyEw8THc+MKUY0+7xJEFYXSFnNiPYF/1+Lzc57IELUnSLXyy+/qHrywRUVuH
         I/yg==
X-Gm-Message-State: AC+VfDzXq+Yl2uIFWzqD7Vd+4ZHW+sR0lNXFxxEYovcp4SH8jjTPjmLG
        BB0KRJWsERq77m4tKX3hs6y2eaouRgE=
X-Google-Smtp-Source: ACHHUZ5Y6uNx7raB+b8cOh1cZPGPMICHINl67pBE3CnRSWyuk0uYk4gqIBKJkpyLzOmSFt11urQuIsG3rBo=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:c08f:0:b0:ba8:93c3:2e3 with SMTP id
 c137-20020a25c08f000000b00ba893c302e3mr7576051ybf.13.1685997807753; Mon, 05
 Jun 2023 13:43:27 -0700 (PDT)
Date:   Mon, 5 Jun 2023 13:43:25 -0700
In-Reply-To: <20230424225854.4023978-4-aaronlewis@google.com>
Mime-Version: 1.0
References: <20230424225854.4023978-1-aaronlewis@google.com> <20230424225854.4023978-4-aaronlewis@google.com>
Message-ID: <ZH5I7e6SwYDnAreK@google.com>
Subject: Re: [PATCH v2 3/6] KVM: selftests: Add additional pages to the guest
 to accommodate ucall
From:   Sean Christopherson <seanjc@google.com>
To:     Aaron Lewis <aaronlewis@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, jmattson@google.com
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Apr 24, 2023, Aaron Lewis wrote:
> Add additional pages to the guest to account for the number of pages
> the ucall framework uses.
> 
> This is done in preparation for adding string formatting options to
> the guest through ucall helpers.

IIUC, this is a bug fix, but things work today because the ucall overhead is small
enough to be covered by the arbitrary 512 page buffer.  If that's correct, please
state that in the changelog.
