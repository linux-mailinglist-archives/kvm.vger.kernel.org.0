Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90E1F4FDC9E
	for <lists+kvm@lfdr.de>; Tue, 12 Apr 2022 13:05:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351885AbiDLKhA (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 12 Apr 2022 06:37:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356408AbiDLKeD (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 12 Apr 2022 06:34:03 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8320C5BD34;
        Tue, 12 Apr 2022 02:35:43 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-2ebf3746f87so99833127b3.6;
        Tue, 12 Apr 2022 02:35:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DsYQ5fyB5xZrRk5QDbuXfzqJsxc8K8LLjkUhASiItKI=;
        b=aUy/cjCNC2BdHzWFTK6IxJtc4SD1bEwFn4+qa7La119l8bgmSAZ1SJeX4t8d6OLOrm
         5RIp4nawA1q2ARRbIkhWsZWQ5O4gQqSFDdnyIr62CEqQlOKIr/r2A+6UuLgRM/qx39qF
         Ide1rCpW3keFEzrdSce7ju0lJF4sHoDYLC1ps8nk3P1PEYl/SCMi8paCyl0O/R/S69q9
         kWACBlsxudFNspCyxx4HJNQmga9cAdCs8M3D3oDbH4onqw7ydz6iRH41Q7Jb/sSqRe2Z
         GLvlCHAcPiA2b74EqZLFy42PHiz694sVcQiUe5WElKlg8WEO5Xolsr+g7j/2/p8l+hb3
         d8xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DsYQ5fyB5xZrRk5QDbuXfzqJsxc8K8LLjkUhASiItKI=;
        b=Q8BdAtH7ckLB/shu7BVhJBSdCqqf9nmS8vqsj2rzAQtL8KS/q/p7N6KXhNyoWuBN0i
         eg73Z4u3/LCoGciBtFlVy1nfejA5VQ8medH8ii8cmNU3XxaY67nftoTGMibfuh29VqEb
         6s0YHe0YNkPyWpJJXWHvy4T/BgqZdt1h+ov5khju+q4zEzBJN/3iaHX3qMLirU2dTgeL
         8liBw0ujRAHnfwN/HkF0QqzTkbfhmwOmMnOTC8Y+p/7K8M0bTN68jtoKOpUINoL2FiNM
         VyURlP6/aUJ+GS6rYWRlrcKk+YSKAnODZK1+akcOrOM50ZjKlsWYR3dyfu8O+fVgAByW
         Xn3w==
X-Gm-Message-State: AOAM532Q9AnuHSUYHp/3a+FIhnYAZAGbIxTQn+CHycZLZWuWQOBcKIAN
        mN5NmGYNZH1iecewgllLzLuQeBEFfaHn4a91TjOUuLUg
X-Google-Smtp-Source: ABdhPJzBaJOtS79qX2LNTnSbSqK9dWYtW3w3LojguBKE3CR/wCMxBClRORXRq4c1y8ATlaxmmyRNfTKaaluv1w/CZss=
X-Received: by 2002:a81:1e86:0:b0:2eb:66b9:3a93 with SMTP id
 e128-20020a811e86000000b002eb66b93a93mr28000522ywe.411.1649756142635; Tue, 12
 Apr 2022 02:35:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220330132152.4568-1-jiangshanlai@gmail.com>
In-Reply-To: <20220330132152.4568-1-jiangshanlai@gmail.com>
From:   Lai Jiangshan <jiangshanlai@gmail.com>
Date:   Tue, 12 Apr 2022 17:35:31 +0800
Message-ID: <CAJhGHyAAekjVGpvUNQ25gspDfif2DW=QdW3eFA1h9hOBtw4uzw@mail.gmail.com>
Subject: Re: [RFC PATCH V3 0/4] KVM: X86: Add and use shadow page with level
 expanded or acting as pae_root
To:     LKML <linux-kernel@vger.kernel.org>, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Cc:     Lai Jiangshan <jiangshan.ljs@antgroup.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Mar 30, 2022 at 9:21 PM Lai Jiangshan <jiangshanlai@gmail.com> wrote:
>
> From: Lai Jiangshan <jiangshan.ljs@antgroup.com>
>


Ping
