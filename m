Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54F1E7D3AB0
	for <lists+kvm@lfdr.de>; Mon, 23 Oct 2023 17:26:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232837AbjJWP0g (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Oct 2023 11:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbjJWP0e (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Oct 2023 11:26:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503F9127
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 08:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698074747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5pB8P5MZI5SVEZkvNE+Ru1LBtul6eHQwWOFc8lfM1dc=;
        b=h6j95748AOWytZDdcWPfkRjCaBAvcGeQBUIv2KYTPOqCGjUR5YwAqj5xjen83bLYXtrus9
        Gu+xMauZ/9uZnocth1wHPYJNQHiCtW5t75lzRaEvAqMbgcVFUN2kBEg3HKE6biGbTZOX13
        kHAsGv0q6d3zsbU0O6AqRMS0SyYmD7o=
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com
 [209.85.210.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-427-SzU9AotXN4eYCXaw7nq4Ag-1; Mon, 23 Oct 2023 11:25:46 -0400
X-MC-Unique: SzU9AotXN4eYCXaw7nq4Ag-1
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6ce0c99f117so5494599a34.2
        for <kvm@vger.kernel.org>; Mon, 23 Oct 2023 08:25:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698074745; x=1698679545;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5pB8P5MZI5SVEZkvNE+Ru1LBtul6eHQwWOFc8lfM1dc=;
        b=HvHdxKCxgdBODUo/lZnGAEgLQl5TFaEDThhia+AS8lFUbEk5y06i3RX3Haqu8HCaEz
         dgDb+9hzzWm2c7u9Rm+RZORO3SwYdkSAMcIvRKehNFXgdyImoTMaOeUw3c79kxsIfJOq
         qF0B7uph7zUvbcpARnDji59ShSp5/s9lHGzfNtRLYhBW/k8B3ovsHqH8nD+eTVFJc9FA
         JtegjEuZbF0Gil0dOfuLQX/yYOv9Qxf5m09V2AqWo8vOK5h9G+2KXhQu5LoSxC1d10DI
         577PD0s5bh7/dn91RZd0mIsgHVgcs3G7B3Apo/HfZFcCtCxq7Q76OfSXiap8MTvxRXFM
         +BHw==
X-Gm-Message-State: AOJu0YzK37/HSLWRWLPaLzSQZpl+IOPLnRUovIPRHK8i1R2q5gf06lwP
        kqqTym/3mX9dZurGf9WqBJ/eS7+qu6CRZMGDt7zXRTMGY3CTHKb6/gjN3xgZVeKvQAxU9+xrxsI
        Iw8NrB0JMqP0M
X-Received: by 2002:a05:6830:13cc:b0:6bd:b29:85d3 with SMTP id e12-20020a05683013cc00b006bd0b2985d3mr9887449otq.24.1698074745367;
        Mon, 23 Oct 2023 08:25:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEoK2+qovEnJ0kBN6PCXBIHQFLPHRIJV2jQ3joRidNulJY5AG6LRxvvWXSsxUzhRkBeB3zQyQ==
X-Received: by 2002:a05:6830:13cc:b0:6bd:b29:85d3 with SMTP id e12-20020a05683013cc00b006bd0b2985d3mr9887424otq.24.1698074745090;
        Mon, 23 Oct 2023 08:25:45 -0700 (PDT)
Received: from rh (p200300c93f0047001ec25c15da4a4a7b.dip0.t-ipconnect.de. [2003:c9:3f00:4700:1ec2:5c15:da4a:4a7b])
        by smtp.gmail.com with ESMTPSA id fb8-20020ad44f08000000b0066d32666a20sm2951492qvb.71.2023.10.23.08.25.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 08:25:44 -0700 (PDT)
Date:   Mon, 23 Oct 2023 17:25:38 +0200 (CEST)
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
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v8 02/13] KVM: arm64: PMU: Set the default PMU for the
 guest before vCPU reset
In-Reply-To: <20231020214053.2144305-3-rananta@google.com>
Message-ID: <6dcbfe5b-2502-0f04-81dc-a4b19e231f06@redhat.com>
References: <20231020214053.2144305-1-rananta@google.com> <20231020214053.2144305-3-rananta@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,
        SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 20 Oct 2023, Raghavendra Rao Ananta wrote:
> From: Reiji Watanabe <reijiw@google.com>
>
> The following patches will use the number of counters information
> from the arm_pmu and use this to set the PMCR.N for the guest
> during vCPU reset. However, since the guest is not associated
> with any arm_pmu until userspace configures the vPMU device
> attributes, and a reset can happen before this event, assign a
> default PMU to the guest just before doing the reset.
>
> Signed-off-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>

Reviewed-by: Sebastian Ott <sebott@redhat.com>

