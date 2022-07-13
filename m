Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2044A572F73
	for <lists+kvm@lfdr.de>; Wed, 13 Jul 2022 09:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234747AbiGMHpJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Jul 2022 03:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234358AbiGMHpI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Jul 2022 03:45:08 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C4AB96F7D8
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 00:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657698306;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OeJ+iFREKEPDGzZIidEw0qYmCZVogFXpaPgElmJEdn4=;
        b=Q3bidCWhVnCNoblXxC5POphG+9H2xaTaIEdrQTOuZvoSKS/iFgym1WkJHxDBIY/ro0X+Sg
        2TAuxmRerJTlpp93uihGD4Aw4VchPN71YXL4eOxjrj4bb2mRlfOboAa9mFBKMKj/uHLjJG
        caLDZU9zSZDNE/3cSDqTnOxOMqKiJFQ=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-102-NgXg7FLvMCeEj2NK7ndlBA-1; Wed, 13 Jul 2022 03:45:02 -0400
X-MC-Unique: NgXg7FLvMCeEj2NK7ndlBA-1
Received: by mail-ej1-f71.google.com with SMTP id hs16-20020a1709073e9000b0072b73a28465so1979114ejc.17
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 00:45:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=OeJ+iFREKEPDGzZIidEw0qYmCZVogFXpaPgElmJEdn4=;
        b=HWYiDL/ydlyzuoczca/K8fd8BQ4OpZfI59/naRCdAugMn3SFHjGXwFVs6jOmUT4Yhi
         JVjqOcuvQZsAekorLeDYPNPxCNtTSVBcbJk9gdSHqA0dKSpQoMCOMnsFIPXJdDlqw689
         /OliLoszfILMEITfgFH7vO6XFfa8skR7K3eZHT/kLVwupCoStocJkLAjItgyafHPk1Uw
         qvppL2JdfPI9i9pAESqRazMkz5wlVbWkLyeCmWsxMAmRVQMDPc6/5bxAms0pj+K6pADC
         YvI0iQnLYMz48ar7eoefbS7TdIDlk/tK3qiOin1Y0QfMQCO2qQM8YI9ZiY+4F7tnpBC4
         FXWg==
X-Gm-Message-State: AJIora/51PIQn/FqjAgNa5EZY9SjtUTC1SkM3qC72HSM91zjkb1NhsLP
        L0ZoTQ0oTmnZqXqO9p9IB24O2PvGnegM4vEj6j6bv8p1ffH6a651JZgOii6FWvg2AwxEyOM1Rf6
        TFnWiq0TsKWGj
X-Received: by 2002:a17:907:2723:b0:72b:5af3:5a11 with SMTP id d3-20020a170907272300b0072b5af35a11mr2069772ejl.584.1657698300815;
        Wed, 13 Jul 2022 00:45:00 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1u0i5rjFfrpSqjEmGzpTqwuvm4Y57W/o6n5JXE6u+yShz8Ylot177o6FwB5C48121akrJRf7Q==
X-Received: by 2002:a17:907:2723:b0:72b:5af3:5a11 with SMTP id d3-20020a170907272300b0072b5af35a11mr2069757ejl.584.1657698300651;
        Wed, 13 Jul 2022 00:45:00 -0700 (PDT)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id e24-20020a50ec98000000b0043a6a7048absm7339793edr.95.2022.07.13.00.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 00:45:00 -0700 (PDT)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Dongli Zhang <dongli.zhang@oracle.com>
Cc:     Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sean Christopherson <seanjc@google.com>
Subject: Re: [PATCH] KVM: nVMX: Always enable TSC scaling for L2 when it was
 enabled for L1
In-Reply-To: <ed923f16-86a7-1f87-f192-c935371dc48c@oracle.com>
References: <20220712135009.952805-1-vkuznets@redhat.com>
 <ed923f16-86a7-1f87-f192-c935371dc48c@oracle.com>
Date:   Wed, 13 Jul 2022 09:44:59 +0200
Message-ID: <87y1wxo3r8.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Dongli Zhang <dongli.zhang@oracle.com> writes:

> Hi Vitaly,
>
> On 7/12/22 6:50 AM, Vitaly Kuznetsov wrote:
>> Windows 10/11 guests with Hyper-V role (WSL2) enabled are observed to
>> hang upon boot or shortly after when a non-default TSC frequency was
>> set for L1. The issue is observed on a host where TSC scaling is
>
> Would you mind helping clarify if it is L1 or L2 that hangs?
>
> The commit message "Windows 10/11 guests with Hyper-V role (WSL2)" confuses me
> if it is L1 or L2 (perhaps due to my lack of knowledge on hyper-v) that hangs.
>

I think it's L2 but I'm not sure: there's no easy way to interract with
L1 (Hyper-V) directly, all the interfaces (UI, network,..) are handled
by L2 (Windows). Prior to the observed 'hang' Hyper-V (L1) programms
synthetic timer in KVM too far in the future but my guess is that it's
doing that on Windows' (L2) behalf, basically just relaying the
request. The issue only shows up with 'hv-reenlightenment' +
'hv-frequencies' (in QEMU's terms) features as in this case both Hyper-V
(L1) and Windows (L2) trust the information about TSC frequency from KVM
but the information turns out to be incorrect for Windows (L2).

-- 
Vitaly

