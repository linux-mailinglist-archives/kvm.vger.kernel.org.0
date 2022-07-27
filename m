Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27AF1582424
	for <lists+kvm@lfdr.de>; Wed, 27 Jul 2022 12:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbiG0KW5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 27 Jul 2022 06:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiG0KWy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 27 Jul 2022 06:22:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9497C37FAE
        for <kvm@vger.kernel.org>; Wed, 27 Jul 2022 03:22:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658917372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xJ74GF4mlhYqy+2/HrHGfYCLzmw6cTg2nUt/Z8f593o=;
        b=bz1/j+Q5PmFByM/1xX4D1jc7ujcc1YS3TYXWOYlWJmOTVyhBkJqx01AoGU+ORgLAlvpECT
        /f4jZ1IgeLmw5r+rNw1+RHvjdhhB5HDc9HCjLnLdpopAsG4gy6F3YBDHPIrAVlCNUdleWQ
        rApi70pTC1KsxVqYnd8TYQsDWbXag+0=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-152-jLVwplDrOyiBnwEvMA7seg-1; Wed, 27 Jul 2022 06:22:51 -0400
X-MC-Unique: jLVwplDrOyiBnwEvMA7seg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id F0A71801585;
        Wed, 27 Jul 2022 10:22:50 +0000 (UTC)
Received: from starship (unknown [10.40.192.46])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2F22A1121314;
        Wed, 27 Jul 2022 10:22:48 +0000 (UTC)
Message-ID: <20dcddad9f6c8384c49f9d8ec95a826df35fc92d.camel@redhat.com>
Subject: Re: [PATCH] KVM: x86: enable TDP MMU by default
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Stoiko Ivanov <s.ivanov@proxmox.com>
Cc:     linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        bgardon@google.com, Jim Mattson <jmattson@google.com>
Date:   Wed, 27 Jul 2022 13:22:48 +0300
In-Reply-To: <ffc99463-6a61-8694-6a4e-3162580f94ee@redhat.com>
References: <20210726163106.1433600-1-pbonzini@redhat.com>
         <20220726165748.76db5284@rosa.proxmox.com>
         <ffc99463-6a61-8694-6a4e-3162580f94ee@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.3
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Tue, 2022-07-26 at 17:43 +0200, Paolo Bonzini wrote:
> On 7/26/22 16:57, Stoiko Ivanov wrote:
> > Hi,
> > 
> > Proxmox[0] recently switched to the 5.15 kernel series (based on the one
> > for Ubuntu 22.04), which includes this commit.
> > While it's working well on most installations, we have a few users who
> > reported that some of their guests shutdown with
> > `KVM: entry failed, hardware error 0x80000021` being logged under certain
> > conditions and environments[1]:
> > * The issue is not deterministically reproducible, and only happens
> >    eventually with certain loads (e.g. we have only one system in our
> >    office which exhibits the issue - and this only by repeatedly installing
> >    Windows 2k22 ~ one out of 10 installs will cause the guest-crash)
> > * While most reports are referring to (newer) Windows guests, some users
> >    run into the issue with Linux VMs as well
> > * The affected systems are from a quite wide range - our affected machine
> >    is an old IvyBridge Xeon with outdated BIOS (an equivalent system with
> >    the latest available BIOS is not affected), but we have
> >    reports of all kind of Intel CPUs (up to an i5-12400). It seems AMD CPUs
> >    are not affected.
> > 
> > Disabling tdp_mmu seems to mitigate the issue, but I still thought you
> > might want to know that in some cases tdp_mmu causes problems, or that you
> > even might have an idea of how to fix the issue without explicitly
> > disabling tdp_mmu?
> 
> If you don't need secure boot, you can try disabling SMM.  It should not 
> be related to TDP MMU, but the logs (thanks!) point at an SMM entry (RIP 
> = 0x8000, CS base=0x7ffc2000).

No doubt about it. It is the issue.

> 
> This is likely to be fixed by 
> https://lore.kernel.org/kvm/20220621150902.46126-1-mlevitsk@redhat.com/.


Speaking of my patch series, anything I should do to move that thing forward?

My approach to preserve the interrupt shadow in SMRAM doesn't seem to be accepted,
so what you think I should do?

Best regards,
	Maxim Levitsky

> 
> Paolo
> 


