Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218424FF7B7
	for <lists+kvm@lfdr.de>; Wed, 13 Apr 2022 15:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbiDMNis (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 13 Apr 2022 09:38:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233721AbiDMNir (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 13 Apr 2022 09:38:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 924A95D5F1
        for <kvm@vger.kernel.org>; Wed, 13 Apr 2022 06:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649856985;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=EhyWe/cai3Ei0JTtT0j3378X3H+cKoa5Jq1NmD8GUUM=;
        b=RmCFDYAChgdj+67HURH4I5TiJZh0yMu0dHkuuDY1s6iVzO5zQY7a694u3AQXLqHn3r2Zb/
        +DA+MfGEFuaqhoq56y9sphpvv9AG5hjID02JdLVWXmSZLwwrqG/Xa6L1XF5Us86C0W2J4z
        esP/AMzcdgKf8jxYT6U3AbOCSpPbN2I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-658-AdPL8sEdO0yq8d7oHkQ7wg-1; Wed, 13 Apr 2022 09:36:24 -0400
X-MC-Unique: AdPL8sEdO0yq8d7oHkQ7wg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B69171014A63;
        Wed, 13 Apr 2022 13:36:23 +0000 (UTC)
Received: from [10.22.8.161] (unknown [10.22.8.161])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5B53FC28109;
        Wed, 13 Apr 2022 13:36:23 +0000 (UTC)
Message-ID: <a713533d-c4c5-2237-58d0-57b812a56ba4@redhat.com>
Date:   Wed, 13 Apr 2022 09:36:23 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
From:   Cole Robinson <crobinso@redhat.com>
Subject: adding 'official' way to dump SEV VMSA
To:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc:     qemu-devel <qemu-devel@nongnu.org>,
        "Singh, Brijesh" <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Dov Murik <dovmurik@linux.ibm.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Hi all,

SEV-ES and SEV-SNP attestation require a copy of the initial VMSA to
validate the launch measurement. For developers dipping their toe into
SEV-* work, the easiest way to get sample VMSA data for their machine is
to grab it from a running VM.

There's two techniques I've seen for that: patch some printing into
kernel __sev_launch_update_vmsa, or use systemtap like danpb's script
here: https://gitlab.com/berrange/libvirt/-/blob/lgtm/scripts/sev-vmsa.stp

Seems like this could be friendlier though. I'd like to work on this if
others agree.

Some ideas I've seen mentioned in passing:

- debugfs entry in /sys/kernel/debug/kvm/.../vcpuX/
- new KVM ioctl
- something with tracepoints
- some kind of dump in dmesg that doesn't require a patch

Thoughts?

Thanks,
Cole

