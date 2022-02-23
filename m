Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFACD4C128E
	for <lists+kvm@lfdr.de>; Wed, 23 Feb 2022 13:16:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240380AbiBWMRV (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 23 Feb 2022 07:17:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240347AbiBWMRT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 23 Feb 2022 07:17:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 1046A3A712
        for <kvm@vger.kernel.org>; Wed, 23 Feb 2022 04:16:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645618611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5pyhUtjUxxFByO5rd0EUPIBmodpcPeTSbHUbynU6E6g=;
        b=UEWt4nO3sGlMD2iKOqyTOoAmM879I0jGLv7CMxVg/JMunkwU3Vcd+6N0GmvFBVBcq5LZVv
        AbJm0vcc9Gltssg7SyI3iPyUrza00rBmbN/VshSmNiyt4isLCSVnoqThc5a6lGkRT2Q9pK
        u+EXJBnXa58Hp1DZjSvN2K1SehRt/cM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-292-uO7Z76d7Nz2fgSwrTmAQTA-1; Wed, 23 Feb 2022 07:16:47 -0500
X-MC-Unique: uO7Z76d7Nz2fgSwrTmAQTA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E99581854E21;
        Wed, 23 Feb 2022 12:16:46 +0000 (UTC)
Received: from starship (unknown [10.40.195.190])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B5FDB7835F;
        Wed, 23 Feb 2022 12:16:45 +0000 (UTC)
Message-ID: <d810a57e5182ff19ec9994df8d7c6605b16c9e86.camel@redhat.com>
Subject: Re: [PATCH 0/3] KVM: SVM: fix race between interrupt delivery and
 AVIC inhibition
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Date:   Wed, 23 Feb 2022 14:16:44 +0200
In-Reply-To: <20220211110117.2764381-1-pbonzini@redhat.com>
References: <20220211110117.2764381-1-pbonzini@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Fri, 2022-02-11 at 06:01 -0500, Paolo Bonzini wrote:
> This is a split and cleaned-up version of Maxim's patch to fix the
> SVM race between interrupt delivery and AVIC inhibition.  The final
> difference is just code movement and formatting.
> 
> Maxim Levitsky (2):
>   KVM: SVM: extract avic_ring_doorbell
>   KVM: SVM: fix race between interrupt delivery and AVIC inhibition
> 
> Paolo Bonzini (1):
>   KVM: SVM: set IRR in svm_deliver_interrupt
> 
>  arch/x86/kvm/svm/avic.c | 73 ++++++++++++++---------------------------
>  arch/x86/kvm/svm/svm.c  | 48 +++++++++++++++++++++++----
>  arch/x86/kvm/svm/svm.h  |  4 ++-
>  arch/x86/kvm/x86.c      |  4 ++-
>  4 files changed, 72 insertions(+), 57 deletions(-)
> 

I know I am beeing late as these patches are already merged,
but as far as I can see, they all look fine.
Thanks!

Best regards,
	Maxim Levitsky

