Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE45167D3A9
	for <lists+kvm@lfdr.de>; Thu, 26 Jan 2023 18:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbjAZR7l (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 26 Jan 2023 12:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjAZR7k (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 26 Jan 2023 12:59:40 -0500
Received: from mail-oo1-xc4a.google.com (mail-oo1-xc4a.google.com [IPv6:2607:f8b0:4864:20::c4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32BDBF9
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 09:59:39 -0800 (PST)
Received: by mail-oo1-xc4a.google.com with SMTP id l1-20020a4ab0c1000000b00511f44a57ebso950127oon.5
        for <kvm@vger.kernel.org>; Thu, 26 Jan 2023 09:59:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=s8lMg0EXnQ3v10Ym+MohqiB63ohQCFcVihzjJlgKe0Y=;
        b=TWCN4fAWwr1bB9IyBXHEMcXtB1Pq3sd+u4/hScAnNgXMUT/UlLNM/rUAHe0iw4UPae
         8Ae/qt6zjW5fehRJK3qGVjyImLg4KZrRgyvmc34pzdnM7eg2m8KkmdUEdOAxj/IxG65R
         FbZvFqtq/y0XHX2UaSZTAzpjKL0utaIR9FDygGDJ9Cropb4RBOpVtXqUvhMSjdrx3H5x
         s8SmZm3b/6eLIU+YQG7XrOA95+RzmduClYrxUwjSPlgVoGb8vzf5yXKvLttwO630lUXD
         7BrimFNe9NNeeirHi/151TF7IU1W6mwh/ZaihTFHF+uKgVN9GIcmgW9CV1y2+/hiOYUl
         2YKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s8lMg0EXnQ3v10Ym+MohqiB63ohQCFcVihzjJlgKe0Y=;
        b=bTtck0oNd8jY0oDGItnQlzd/HgI6x/4fQp+2Of2DOrvIMQfpUhNcuCYC4O0YrRiJpb
         MZlLp7ky9lkd7E1BvkI/WTQ4S96jJoxUdHhGtzFWI2LkUEdjDG+k4X7bbuC9ApoLvsMg
         AOKLO1jIxohBZvcsV0kFOw85iBPydciZ1KHtiI2IUQ4IfXx4b4aeUkc4wjpGKcLZEBvU
         44mYTUpQojdRqMnSzp0/ps8jqMLS9X5HZ3QU6UPvGCKEhUINIMx/eLBqrStepx7K2jbj
         FjIN3gRVxD+Vwy3WvmEwLcqMudn1/kaQDbKJuqhrLsQ4hOum0MqF/4XmW2dsx3RDlYn7
         tu4g==
X-Gm-Message-State: AFqh2krcpz5SEqK3TbJMWV1l1rSvncP/NwBxscHpwGQ2UyAfUhpemoiG
        eQIyxeY5UU4U+Z01fByIhffVS7Y+TMA8ZlTvUw==
X-Google-Smtp-Source: AMrXdXsw0LPe4dqem8m7McMq3Ii81IGujix2zE4k3PE473L6qKq7Yooz2tpsp3JAxI0NDlGTlV2szNY6J8TECG1h2A==
X-Received: from coltonlewis-kvm.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:14ce])
 (user=coltonlewis job=sendgmr) by 2002:a9d:6385:0:b0:686:47e7:ab87 with SMTP
 id w5-20020a9d6385000000b0068647e7ab87mr2272607otk.53.1674755978501; Thu, 26
 Jan 2023 09:59:38 -0800 (PST)
Date:   Thu, 26 Jan 2023 17:59:37 +0000
In-Reply-To: <Y8cJg+RDLgAFrG+O@google.com> (message from Ricardo Koller on
 Tue, 17 Jan 2023 12:48:03 -0800)
Mime-Version: 1.0
Message-ID: <gsntedrhqira.fsf@coltonlewis-kvm.c.googlers.com>
Subject: Re: [PATCH 2/3] KVM: selftests: Collect memory access latency samples
From:   Colton Lewis <coltonlewis@google.com>
To:     Ricardo Koller <ricarkol@google.com>
Cc:     kvm@vger.kernel.org, pbonzini@redhat.com, maz@kernel.org,
        dmatlack@google.com, seanjc@google.com, bgardon@google.com,
        oupton@google.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Ricardo Koller <ricarkol@google.com> writes:


>> Resevoir sampling means despite keeping only a small number of

> Could you add a reference? I'm trying to understand the algorithm, but
> I'm not even sure what's the version implemented ("Optimal: Algorithm
> L"?).


I can add an external link to Wikipedia. That was the source I used. The
version implemented here is the simple version that Wikipedia names
"Algorithm R".
