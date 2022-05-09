Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE13B5209BC
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 01:58:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbiEJABy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 May 2022 20:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232640AbiEJABw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 May 2022 20:01:52 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC6242BD0EF
        for <kvm@vger.kernel.org>; Mon,  9 May 2022 16:57:56 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id w17-20020a17090a529100b001db302efed6so710298pjh.4
        for <kvm@vger.kernel.org>; Mon, 09 May 2022 16:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CM1ZHXJBH+7WPe2guc79jxSpfRuS2k3X5i8S5q0s/Ic=;
        b=N9/pCRotE4fVphwsb4c28RWabUDzJPxC0pJGDYOqwmkWk7vLJLadD20owReFqiyZJ3
         xy7jJLHxwjm55om+ejj2Jy5wcEDmWBpmmmx2fMG8x0gJKTzfAO78UwyWOsFyiaZIQcQu
         zxzdLtuag+Ze9QcKZZuq8SXX75fb12tc7KhOhgeh6PYZSpwv1jySnX1ypoHHjMwEfSCw
         otS81bq0ItHye82Ug0N5hayfgMQZYiO+AfEpsHf9fSSX5o4ff526Id5I1rPAeO7PRWft
         f6RqtzEAcWB+GISMPR425yMp1rZdNGnuPJfL2R7kHWlcaQpvBz6IeZNrQcd6rEgMf8Cj
         qchA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CM1ZHXJBH+7WPe2guc79jxSpfRuS2k3X5i8S5q0s/Ic=;
        b=xUxPc/Hdk+Q5SN6y2D3ygE9LiuGVyTZy4kIuyqw9Tfec6bxQkMjvlOBX0WiDkSI/DB
         bLBJ+ldmwaebvIJZSQrgs+FEdF0X3scyaU3HlSOVhFrikZAI8jkuUjbX7TttLse1GqQS
         lG+IxMytdj+WFfHDdGUlt0V8np3jwLghkih/tWgaN7P8EZ8nbst6vq95rsniBQxph3Tl
         JHTKkxh3qN2xdC7oLY6fU+J8W6oAofJdfVWkWZWRJc3gqkNgiX2IeltAaJvQKlf6ZI7z
         Y9Sah5RhPEoE2yZxQDFasb9AQLghAPvUReIwBPQIcadVOF6G0qKy99eX6G7c8bqTJoZh
         DZWQ==
X-Gm-Message-State: AOAM532nUvGtTZ+xFyct5lR06BfhhvI7zZgDlhvJayXUVAWmcPkw8DCD
        kcWl67fZ75+TbNrFYifcQHpglw==
X-Google-Smtp-Source: ABdhPJxrApBPnduQGqK5wGTxrQqVQOaL8+bhBuKw1dE2FG7xBRVGHd2knlVaUqt4QXcjWickbHvnaw==
X-Received: by 2002:a17:902:f789:b0:156:5f56:ddff with SMTP id q9-20020a170902f78900b001565f56ddffmr18504210pln.116.1652140676125;
        Mon, 09 May 2022 16:57:56 -0700 (PDT)
Received: from google.com (157.214.185.35.bc.googleusercontent.com. [35.185.214.157])
        by smtp.gmail.com with ESMTPSA id pt7-20020a17090b3d0700b001cd630f301fsm277263pjb.36.2022.05.09.16.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 May 2022 16:57:55 -0700 (PDT)
Date:   Mon, 9 May 2022 23:57:52 +0000
From:   Sean Christopherson <seanjc@google.com>
To:     Wei Zhang <zhanwei@google.com>
Cc:     Suleiman Souhlal <suleiman@google.com>,
        Sangwhan Moon <sxm@google.com>, Ingo Molnar <mingo@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] KVM: x86: Fix incorrect VM-exit profiling
Message-ID: <YnmqgFkhqWklrQIw@google.com>
References: <20220412195846.3692374-1-zhanwei@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412195846.3692374-1-zhanwei@google.com>
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Apr 12, 2022, Wei Zhang wrote:
> The profile=kvm boot option has been useful because it provides a
> convenient approach to profile VM exits.

What exactly are you profiling?  Where the guest executing at any given exit?  Mostly
out of curiosity, but also in the hope that we might be able to replace profiling with
a dedicated KVM stat(s).
