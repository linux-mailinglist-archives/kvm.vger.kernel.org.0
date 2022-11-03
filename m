Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 411F16188D0
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 20:34:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiKCTeU (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 15:34:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiKCTeT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 15:34:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03F161F9D9
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 12:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667504007;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bHrHw67H9V40qrnDXssLTsxUZ9uLutx6BAx0o7ln+HQ=;
        b=KejkPwYt2au5GpvN1Qh0KA878HSbh5EnK/i74TDp2gOWCjZJLPDhLfKx90ZZwEMsOgSnBE
        XQEQeP4aEx8naeddq/VBgIKWKglmkNfC5gdYS5lvDXHlWJU/2Y4ff+iqU6qQ6afDzkqcoJ
        BX0ZUnB4Stg0LKswanX7sEEVaIvpdfk=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-351-43bcY7QXO7OzfT3cxqPYqA-1; Thu, 03 Nov 2022 15:33:26 -0400
X-MC-Unique: 43bcY7QXO7OzfT3cxqPYqA-1
Received: by mail-qt1-f199.google.com with SMTP id cm12-20020a05622a250c00b003a521f66e8eso2491844qtb.17
        for <kvm@vger.kernel.org>; Thu, 03 Nov 2022 12:33:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bHrHw67H9V40qrnDXssLTsxUZ9uLutx6BAx0o7ln+HQ=;
        b=1UF4c1v5KB1EqJr8wmPrlsNuBcg9/f9yv154zjdanU3aK0rr680A/60oY1Yu4KWIMZ
         QY3thfDgoBK3dcEmxvlfr2oUPmb7Gr80SxQTVzfq+CrZk59DuhXGsXW6exBuYusJfQ18
         HzShUzP4kHwv2vNMg4jjTOoj+1apouUOYLI/ei75C4aT+C7A+HSNHgrNM6IjF3V5F2qM
         e1gO/dugHfeghWs0qazf6ZpSQDW7vALxbqwgYYDGQcPgRzX++Qi2RNxhvBj8Q2YE1edX
         ugPkRTNeK9Rq5aNaB7pyOhaFFbzSKxM06d3YMDM9VI4RcWwbXBR603owuTxVay60f1bR
         DS/A==
X-Gm-Message-State: ACrzQf3wH6IQBeba+Bo3UzDQ7CsOLrH7DgebK+ewVHrbFSd05u4QavO6
        p15qMUh33Ty29znvG9GUXAypbMG3GRNcVaCaTEOVFA2fnTdSowCXUFqisfAEjGWgZkkK4Q4TH4V
        Tf9piwV6bjpkz
X-Received: by 2002:ac8:4e89:0:b0:39c:c025:887a with SMTP id 9-20020ac84e89000000b0039cc025887amr26208763qtp.413.1667504005630;
        Thu, 03 Nov 2022 12:33:25 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4R+CVRPC2arwivP79Qld/IvHiKE/cb49gnSORd3djcfXtq8j0yR40+W1k4QyB1f4cAEtdMdA==
X-Received: by 2002:ac8:4e89:0:b0:39c:c025:887a with SMTP id 9-20020ac84e89000000b0039cc025887amr26208742qtp.413.1667504005412;
        Thu, 03 Nov 2022 12:33:25 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id h4-20020a05620a400400b006eea4b5abcesm1353401qko.89.2022.11.03.12.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 12:33:24 -0700 (PDT)
Date:   Thu, 3 Nov 2022 15:33:23 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Gavin Shan <gshan@redhat.com>
Cc:     kvmarm@lists.linux.dev, kvm@vger.kernel.org,
        kvmarm@lists.cs.columbia.edu, andrew.jones@linux.dev,
        ajones@ventanamicro.com, maz@kernel.org, bgardon@google.com,
        catalin.marinas@arm.com, dmatlack@google.com, will@kernel.org,
        pbonzini@redhat.com, oliver.upton@linux.dev, seanjc@google.com,
        james.morse@arm.com, shuah@kernel.org, suzuki.poulose@arm.com,
        alexandru.elisei@arm.com, zhenyzha@redhat.com, shan.gavin@gmail.com
Subject: Re: [PATCH v7 4/9] KVM: Support dirty ring in conjunction with bitmap
Message-ID: <Y2QXg5BMl8lMufro@x1n>
References: <20221031003621.164306-1-gshan@redhat.com>
 <20221031003621.164306-5-gshan@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20221031003621.164306-5-gshan@redhat.com>
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Mon, Oct 31, 2022 at 08:36:16AM +0800, Gavin Shan wrote:
> ARM64 needs to dirty memory outside of a VCPU context when VGIC/ITS is
> enabled. It's conflicting with that ring-based dirty page tracking always
> requires a running VCPU context.
> 
> Introduce a new flavor of dirty ring that requires the use of both VCPU
> dirty rings and a dirty bitmap. The expectation is that for non-VCPU
> sources of dirty memory (such as the VGIC/ITS on arm64), KVM writes to
> the dirty bitmap. Userspace should scan the dirty bitmap before migrating
> the VM to the target.
> 
> Use an additional capability to advertise this behavior. The newly added
> capability (KVM_CAP_DIRTY_LOG_RING_WITH_BITMAP) can't be enabled before
> KVM_CAP_DIRTY_LOG_RING_ACQ_REL on ARM64. In this way, the newly added
> capability is treated as an extension of KVM_CAP_DIRTY_LOG_RING_ACQ_REL.
> 
> Suggested-by: Marc Zyngier <maz@kernel.org>
> Suggested-by: Peter Xu <peterx@redhat.com>
> Co-developed-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> Signed-off-by: Gavin Shan <gshan@redhat.com>

Acked-by: Peter Xu <peterx@redhat.com>

-- 
Peter Xu

