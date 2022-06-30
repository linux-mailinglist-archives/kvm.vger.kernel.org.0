Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D409561B0D
	for <lists+kvm@lfdr.de>; Thu, 30 Jun 2022 15:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235160AbiF3NLR (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 30 Jun 2022 09:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235110AbiF3NLQ (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 30 Jun 2022 09:11:16 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 754922CDF5
        for <kvm@vger.kernel.org>; Thu, 30 Jun 2022 06:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656594664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jV/u9DidSFdfO13oE75Yy4sdwZ39Z5PR0U85p6rtOgg=;
        b=L9EliN3y+tiYSifp8zVDk/cCRKvoSk59abzzjc0vBJuWXVgrXSuOsRD4LuE2Yqsbq18uTE
        5uedSxhyP29zIQhMoGI5fdnVZMFworyHWXF9ZDIQC6eJkhNKGOPosyWDxA/aqOhg9D+rbT
        kSayRUQe36eABg0rGXdzHSW2Oe+73Y8=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-100-nDUhfL2wNSG3Sf4GqyTzVw-1; Thu, 30 Jun 2022 09:11:03 -0400
X-MC-Unique: nDUhfL2wNSG3Sf4GqyTzVw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 997511C1BD22;
        Thu, 30 Jun 2022 13:11:01 +0000 (UTC)
Received: from starship (unknown [10.40.194.38])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1FA309D63;
        Thu, 30 Jun 2022 13:10:58 +0000 (UTC)
Message-ID: <b11b2a29824e69d57f6b9bb5675aa957e4c081ce.camel@redhat.com>
Subject: Re: [PATCH v2 00/21] KVM: x86: Event/exception fixes and cleanups
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Jim Mattson <jmattson@google.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Oliver Upton <oupton@google.com>,
        Peter Shier <pshier@google.com>
Date:   Thu, 30 Jun 2022 16:10:58 +0300
In-Reply-To: <CALMp9eQkA-YeUFd=6Q+bRbtDT+UZO0jtPkEoZbqU1uDqMGp+xw@mail.gmail.com>
References: <20220614204730.3359543-1-seanjc@google.com>
         <7e05e0befa13af05f1e5f0fd8658bc4e7bdf764f.camel@redhat.com>
         <CALMp9eSkdj=kwh=4WHPsWZ1mKr9+0VSB527D5CMEx+wpgEGjGw@mail.gmail.com>
         <f55889a50ba404381e3edc1a192770f2779d40f1.camel@redhat.com>
         <CALMp9eQkA-YeUFd=6Q+bRbtDT+UZO0jtPkEoZbqU1uDqMGp+xw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.11.54.5
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Thu, 2022-06-30 at 05:17 -0700, Jim Mattson wrote:
> On Thu, Jun 30, 2022 at 1:22 AM Maxim Levitsky <mlevitsk@redhat.com> wrote:
> 
> > I can't access this document for some reason (from my redhat account, which is gmail as well).
> 
> Try this one: https://docs.google.com/spreadsheets/d/13Yp7Cdg3ZyKoeZ3Qebp3uWi7urlPNmo5CQU5zFlayzs
> 
Thanks, now I can access both documents.

Best regards,
	Maxim Levitsky

