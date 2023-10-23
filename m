Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 905017D3AA7
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 17:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbjJWPZ3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 11:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231449AbjJWPZ0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 11:25:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A7E93
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 08:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698074684;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YrnXzVdFyG8cEywC86c0X/I901FAAiWZF1AhPDWq6c4=;
        b=NtAWkSbad+KHtd/fIKf8rL7pJZYrfNBGemH063DgcImvxzsHwzSEiEXJZb/UvJe6SS4/sQ
        BYSxmNInjpjevkHBdssfln1a18UEa5AaggDvTE+SM+NhIKrHiW9XWoz6Eg3Ri+2dm7MmIr
        /lJ30S6Ohv8irZl7pCJEcTSUlm4/SCY=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-562-w0-7LRkuOHSDj8h9OjfpqA-1; Mon, 23 Oct 2023 11:24:42 -0400
X-MC-Unique: w0-7LRkuOHSDj8h9OjfpqA-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7788f0f099fso481493685a.1
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 08:24:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698074682; x=1698679482;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YrnXzVdFyG8cEywC86c0X/I901FAAiWZF1AhPDWq6c4=;
        b=OjCzp9AyrmR610wbdh9y8ccc30E2LmICEseVntJ9ifF/4iBzoSrpC0DEvsxJ/oReRz
         oxPawGZtBXQI9+5d/zKHhecH5KuCSbZhv3pS/s6RYZNImUXCMWhG7+8KRsu9B0Xg2Ned
         SO1urI1adIGKg8yPKZrCbwJDWSFOLPnjvCR2n0QSh1O0GqFWTlSEjnYhiyfxCsgPfPlg
         O6Vs43eW0qUjrrW0EnqDcc5SOiJHHa9QGt6G5qtglOAGx7EEugu9SJvO7SR8897amnx0
         1oDHiPLZy6YVf/phfPWf1LrVK+YkUFJU7IvC3sqP2m5OyG3HrxIMvVeOXsD4zHWsU1+i
         yhmQ==
X-Gm-Message-State: AOJu0YzpcGaxUMAAj/0fdCgvv4t1Z9WxEEkKGPm95ilIE8UyhnCRCSFf
        yCpUhgeo2l2dXlBXkW3GuqyhGV2NSTVi0woX+Ak1SluikJshcpb40y4JUapW4WAvw7vSyFadBzv
        s4OS61ciOQe0V
X-Received: by 2002:a05:620a:2909:b0:779:db14:53bd with SMTP id m9-20020a05620a290900b00779db1453bdmr3606666qkp.32.1698074682199;
        Mon, 23 Oct 2023 08:24:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE0oXNOI2bZ0Q7EOH0xkSQPuJV1uT5Nv9oLcwOjU3v7FEChoNMD+vNwx5JP/j0OgNyb9geOCQ==
X-Received: by 2002:a05:620a:2909:b0:779:db14:53bd with SMTP id m9-20020a05620a290900b00779db1453bdmr3606648qkp.32.1698074682007;
        Mon, 23 Oct 2023 08:24:42 -0700 (PDT)
Received: from rh (p200300c93f0047001ec25c15da4a4a7b.dip0.t-ipconnect.de. [2003:c9:3f00:4700:1ec2:5c15:da4a:4a7b])
        by smtp.gmail.com with ESMTPSA id w20-20020a05620a149400b0076cbcf8ad3bsm2757613qkj.55.2023.10.23.08.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 08:24:41 -0700 (PDT)
Date:   Mon, 23 Oct 2023 17:24:35 +0200 (CEST)
From:   Sebastian Ott <sebott@redhat.com>
To:     Raghavendra Rao Ananta <rananta@google.com>
cc:     Oliver Upton <oliver.upton@linux.dev>,
        Marc Zyngier <maz@kernel.org>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        James Morse <james.morse@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Shaoqin Huang <shahuang@redhat.com>,
        Jing Zhang <jingzhangos@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Colton Lewis <coltonlewis@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Eric Auger <eric.auger@redhat.com>
Subject: Re: [PATCH v8 01/13] KVM: arm64: PMU: Introduce helpers to set the
 guest's PMU
In-Reply-To: <20231020214053.2144305-2-rananta@google.com>
Message-ID: <ed5c4213-d4ee-2c51-fff4-a3906876ee5a@redhat.com>
References: <20231020214053.2144305-1-rananta@google.com> <20231020214053.2144305-2-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Oct 2023, Raghavendra Rao Ananta wrote:
> From: Reiji Watanabe <reijiw@google.com>
>
> Introduce new helper functions to set the guest's PMU
> (kvm->arch.arm_pmu) either to a default probed instance or to a
> caller requested one, and use it when the guest's PMU needs to
> be set. These helpers will make it easier for the following
> patches to modify the relevant code.
>
> No functional change intended.
>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Eric Auger <eric.auger@redhat.com>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

