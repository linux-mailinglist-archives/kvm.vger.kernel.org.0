Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 903936CDB4C
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 15:57:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230336AbjC2N5Y (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 09:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjC2N5W (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 09:57:22 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13CA8B6
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 06:57:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BC4B61F7AB;
        Wed, 29 Mar 2023 13:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680098229; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G4zDWPpQKlg/1synQOq2eKCiMKJAG5BFd3bkstfjsAc=;
        b=AmzL6iqpeiEK1id6TL32sQnm6Y374nlnEH4osl6hzdXuGdhmbHNJfy+Q2No4asqepf/cy9
        08eRMENqQfxW+9pTmwzMs1f5wp9dh1hx/J+RuH7P7yBn9dqeuAY4QxjeMPs3gpRegi/vH3
        NnRaNflIQV6mJjDgOCJhTGzf9XL1yS8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680098229;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G4zDWPpQKlg/1synQOq2eKCiMKJAG5BFd3bkstfjsAc=;
        b=dmJBKyEsBUIhf/3xrr9UgbldMiNEhI//bUZR++vDYMfWkzRVgwhmiRPUCAWntK/75+zeXS
        R+z/Kyram2p449Aw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 34C04138FF;
        Wed, 29 Mar 2023 13:57:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HfrvOrRDJGSBJAAAMHmgww
        (envelope-from <farosas@suse.de>); Wed, 29 Mar 2023 13:57:08 +0000
From:   Fabiano Rosas <farosas@suse.de>
To:     Philippe =?utf-8?Q?Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
        qemu-devel@nongnu.org
Cc:     Halil Pasic <pasic@linux.ibm.com>,
        David Gibson <david@gibson.dropbear.id.au>,
        Daniel Henrique Barboza <danielhb413@gmail.com>,
        qemu-ppc@nongnu.org, Yanan Wang <wangyanan55@huawei.com>,
        David Hildenbrand <david@redhat.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>,
        Eduardo Habkost <eduardo@habkost.net>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
        Greg Kurz <groug@kaod.org>, kvm@vger.kernel.org,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Peter Maydell <peter.maydell@linaro.org>,
        Alex =?utf-8?Q?Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Thomas Huth <thuth@redhat.com>,
        Richard Henderson <richard.henderson@linaro.org>,
        qemu-s390x@nongnu.org, qemu-arm@nongnu.org,
        Philippe =?utf-8?Q?Mathieu-Da?= =?utf-8?Q?ud=C3=A9?= 
        <philmd@linaro.org>,
        =?utf-8?Q?C=C3=A9dric?= Le Goater <clg@kaod.org>
Subject: Re: [PATCH-for-8.0 v2 1/3] softmmu: Restrict cpu_check_watchpoint /
 address_matches to TCG accel
In-Reply-To: <20230328173117.15226-2-philmd@linaro.org>
References: <20230328173117.15226-1-philmd@linaro.org>
 <20230328173117.15226-2-philmd@linaro.org>
Date:   Wed, 29 Mar 2023 10:57:06 -0300
Message-ID: <87v8ijy825.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org> writes:

> Both cpu_check_watchpoint() and cpu_watchpoint_address_matches()
> are specific to TCG system emulation. Declare them in "tcg-cpu-ops.h"
> to be sure accessing them from non-TCG code is a compilation error.
>
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>

Reviewed-by: Fabiano Rosas <farosas@suse.de>
