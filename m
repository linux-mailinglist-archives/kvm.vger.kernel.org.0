Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A812617D00
	for <lists+kvm@lfdr.de>; Thu,  3 Nov 2022 13:47:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbiKCMrs (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Nov 2022 08:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbiKCMrh (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Nov 2022 08:47:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296B1140C7
        for <kvm@vger.kernel.org>; Thu,  3 Nov 2022 05:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667479595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6Lh+aq0KrT7YT7zq9EYFKfpsO05/wse1gFPTUN4LGR8=;
        b=OGcOkRMzvKi9W8TFAkyajOiurd/jzR3FxYOv+VxAk2Mp6OYk5SpPTnr0UJ6sCQPonK60+J
        /zM4YRqrcRWv24MKcrHyRIs3W/ByN6HuMSkCjWlHG5fS5EimZmyiWoMJAbzz6MECao+s8R
        voNDIw3orFR2OKtDjhryJQ4hxBCqr7k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-425-rDTZzCaNMfqkeMoeZ1x5EQ-1; Thu, 03 Nov 2022 08:46:33 -0400
X-MC-Unique: rDTZzCaNMfqkeMoeZ1x5EQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 145AE823F77;
        Thu,  3 Nov 2022 12:46:31 +0000 (UTC)
Received: from localhost (unknown [10.39.193.104])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5E6A2492B06;
        Thu,  3 Nov 2022 12:46:30 +0000 (UTC)
From:   Cornelia Huck <cohuck@redhat.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marc Zyngier <maz@kernel.org>,
        Huacai Chen <chenhuacai@kernel.org>,
        Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
        Anup Patel <anup@brainfault.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Janosch Frank <frankja@linux.ibm.com>,
        Claudio Imbrenda <imbrenda@linux.ibm.com>,
        Matthew Rosato <mjrosato@linux.ibm.com>,
        Eric Farman <farman@linux.ibm.com>,
        Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>
Cc:     James Morse <james.morse@arm.com>,
        Alexandru Elisei <alexandru.elisei@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        Atish Patra <atishp@atishpatra.org>,
        David Hildenbrand <david@redhat.com>, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, kvm-riscv@lists.infradead.org,
        linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Isaku Yamahata <isaku.yamahata@intel.com>,
        Fabiano Rosas <farosas@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Chao Gao <chao.gao@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yuan Yao <yuan.yao@intel.com>
Subject: Re: [PATCH 04/44] KVM: Teardown VFIO ops earlier in kvm_exit()
In-Reply-To: <20221102231911.3107438-5-seanjc@google.com>
Organization: Red Hat GmbH
References: <20221102231911.3107438-1-seanjc@google.com>
 <20221102231911.3107438-5-seanjc@google.com>
User-Agent: Notmuch/0.37 (https://notmuchmail.org)
Date:   Thu, 03 Nov 2022 13:46:28 +0100
Message-ID: <87edukxl23.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

On Wed, Nov 02 2022, Sean Christopherson <seanjc@google.com> wrote:

> Move the call to kvm_vfio_ops_exit() further up kvm_exit() to try and
> bring some amount of symmetry to the setup order in kvm_init(), and more
> importantly so that the arch hooks are invoked dead last by kvm_exit().
> This will allow arch code to move away from the arch hooks without any
> change in ordering between arch code and common code in kvm_exit().
>
> That kvm_vfio_ops_exit() is called last appears to be 100% arbitrary.  It
> was bolted on after the fact by commit 571ee1b68598 ("kvm: vfio: fix
> unregister kvm_device_ops of vfio").  The nullified kvm_device_ops_table
> is also local to kvm_main.c and is used only when there are active VMs,
> so unless arch code is doing something truly bizarre, nullifying the
> table earlier in kvm_exit() is little more than a nop.
>
> Signed-off-by: Sean Christopherson <seanjc@google.com>
> ---
>  virt/kvm/kvm_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Looks safe to me.

Reviewed-by: Cornelia Huck <cohuck@redhat.com>

