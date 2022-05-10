Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2603D521E1B
	for <lists+kvm@lfdr.de>; Tue, 10 May 2022 17:20:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345587AbiEJPX7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 10 May 2022 11:23:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345578AbiEJPWw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 10 May 2022 11:22:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9011787A38
        for <kvm@vger.kernel.org>; Tue, 10 May 2022 08:07:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652195240;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fI2ZawHCdRIhMJCwYHvAzY/bTTBNnIpXKClvdmq4TdY=;
        b=NifialAzbWWvu6hPhG2DqsNPC5IVxaAloaTR9uOvgSJttOXR53makAAJ+bMpP2ScBTFG0K
        eb9Ux3qGa8Rxcgg5j84865ApXRSDhgPpPej57/gPsnL1aC/D8pAffo39bTQ7L9PYE8+DFm
        KNCIpzb5Z1L5P9gLyaqkch9Io/p6aUY=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-470-caOQUNsuOAqj1TuHv_ir7A-1; Tue, 10 May 2022 11:07:16 -0400
X-MC-Unique: caOQUNsuOAqj1TuHv_ir7A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CF6F43C021AB;
        Tue, 10 May 2022 15:07:15 +0000 (UTC)
Received: from virtlab701.virt.lab.eng.bos.redhat.com (virtlab701.virt.lab.eng.bos.redhat.com [10.19.152.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 72BB89E72;
        Tue, 10 May 2022 15:07:15 +0000 (UTC)
From:   Paolo Bonzini <pbonzini@redhat.com>
To:     Yang Weijiang <weijiang.yang@intel.com>
Cc:     pbonzini@redhat.com, likexu@tencent.com,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] KVM: selftests: x86: Skip unsupported test when Arch LBR is available
Date:   Tue, 10 May 2022 11:06:38 -0400
Message-Id: <20220510150637.1774645-1-pbonzini@redhat.com>
In-Reply-To: <20220510035028.21042-1-weijiang.yang@intel.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi,

> -	ret = _vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_LBR_FMT);
> -	TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
> +	/* Note, on Arch LBR capable platforms, LBR_FMT in perf capability msr is 0x3f,
> +	 * so skip below test if running on these platforms. */
> +	if (host_cap.lbr_format != PMU_CAP_LBR_FMT) {
> +		ret = _vcpu_set_msr(vm, 0, MSR_IA32_PERF_CAPABILITIES, PMU_CAP_LBR_FMT);
> +		TEST_ASSERT(ret == 0, "Bad PERF_CAPABILITIES didn't fail.");
> +	}

Why not try a different value?

Paolo


