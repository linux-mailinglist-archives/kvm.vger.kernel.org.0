Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87589726143
	for <lists+kvm@lfdr.de>; Wed,  7 Jun 2023 15:28:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240772AbjFGN2e (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 7 Jun 2023 09:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240683AbjFGN2d (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 7 Jun 2023 09:28:33 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC2C19BC
        for <kvm@vger.kernel.org>; Wed,  7 Jun 2023 06:27:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686144467;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qHkZwA8x2A2PX4DJxkdSMqpn58BpxAzukl16KY5zfOA=;
        b=eHdXDnvtlsCSTgr0XkYTMYMbcnVbcjYrUaHS0MRGS1iwa6FOfVIePkHt2aTvKaRTzXVGAJ
        jZXlKPVsoerumIA4Mjrf03FQiYnrwncH9ejcqJux990Ty2lGNgAO2lXCPUn/9p7z0ilMgn
        G5ZkmEANm9FvDtEKfKWcAgVjXUBlwBQ=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-149-0kHdJ9WXPqutMzRLbttQPw-1; Wed, 07 Jun 2023 09:27:46 -0400
X-MC-Unique: 0kHdJ9WXPqutMzRLbttQPw-1
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-75b337f2504so152764385a.0
        for <kvm@vger.kernel.org>; Wed, 07 Jun 2023 06:27:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686144465; x=1688736465;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qHkZwA8x2A2PX4DJxkdSMqpn58BpxAzukl16KY5zfOA=;
        b=PkLMT0r4vNB8mYE22zq1F86UOFYGdVu2JUF0p3ZfejW5fnZpBzzHK9uqDjxDyo6C/q
         oxipUskJoNwSN1u2Orsh2GuXmeD4s8xAK8ZbneJq6yNmeoBpmh5dYD0RTvYbhsITLGhK
         m96zzs0giavc+P8+KxmRSaVj5xmvJcja6CVdiyIR9I05YB7ulcAZGX6L61SQTaeNAB6B
         S7/Yas3dQJnVsIMEfXy8UpqK+uc6Rh2TCGrAi9dsmzYwN3ObnQvOkWcC/O4xdiXDFY0Y
         VfJYkKo6a0oy2BkE+hKvUkx4Xi6dd2m4Puff5CQAaoVTV4zf3mzpj0Fj2VKe28ZeCocg
         bcwQ==
X-Gm-Message-State: AC+VfDx5qRF0W5zd8srtAO+4lDg3FaETpb98dknZVAFeAi02g8ey5Qn2
        aUWxBoFTgcCSwRtU4vTTSdfiLjm/iY1dJI4OJgdz25DD3pG/Ny5cqrgAw78cg65TuNY+B24OfVW
        k327z95KaOBWARZXgK246
X-Received: by 2002:a05:620a:6009:b0:75d:5357:78a0 with SMTP id dw9-20020a05620a600900b0075d535778a0mr2070913qkb.6.1686144465647;
        Wed, 07 Jun 2023 06:27:45 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6/OtuOZtvT3m5LEgLymrip3rZbO7MdsJzF45g0WE0IfUZIPuV2ksrzNfgPGbxaGZre8maCzg==
X-Received: by 2002:a05:620a:6009:b0:75d:5357:78a0 with SMTP id dw9-20020a05620a600900b0075d535778a0mr2070896qkb.6.1686144465417;
        Wed, 07 Jun 2023 06:27:45 -0700 (PDT)
Received: from x1n (cpe5c7695f3aee0-cm5c7695f3aede.cpe.net.cable.rogers.com. [99.254.144.39])
        by smtp.gmail.com with ESMTPSA id ou47-20020a05620a622f00b0074d60b697a6sm5648210qkn.12.2023.06.07.06.27.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 06:27:44 -0700 (PDT)
Date:   Wed, 7 Jun 2023 09:27:43 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Sean Christopherson <seanjc@google.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] KVM: selftests: Allow specify physical cpu list in
 demand paging test
Message-ID: <ZICFz6khhyBjsMiS@x1n>
References: <20230607001226.1398889-1-seanjc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230607001226.1398889-1-seanjc@google.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, Jun 06, 2023 at 05:12:26PM -0700, Sean Christopherson wrote:
> From: Peter Xu <peterx@redhat.com>
> 
> Mimic the dirty log test and allow the user to pin demand paging test
> tasks to physical CPUs.
> 
> Put the help message into a general helper as suggested by Sean.
> 
> Signed-off-by: Peter Xu <peterx@redhat.com>
> Link: https://lore.kernel.org/r/20230601184256.180413-1-peterx@redhat.com
> [sean: rebase, tweak arg ordering, add "print" to helper, print program name]
> Signed-off-by: Sean Christopherson <seanjc@google.com>

Thanks, Sean!

-- 
Peter Xu

