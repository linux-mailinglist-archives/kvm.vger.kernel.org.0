Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A45B6CDB67
	for <lists+kvm@lfdr.de>; Wed, 29 Mar 2023 16:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjC2OCn (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 29 Mar 2023 10:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjC2OCm (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 29 Mar 2023 10:02:42 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34299527C
        for <kvm@vger.kernel.org>; Wed, 29 Mar 2023 07:02:11 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D9B681FDD1;
        Wed, 29 Mar 2023 14:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680098529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0v7smsUOkD+0PDWZRSps2dW8wIjUlqektUnRtiqndwY=;
        b=x+WCetoCefp5zIX8H2o3l0n5Qc0ZTC8CAqx87CZ0otdreXGDyg7ulFSUHkWaKiV6kJRsFt
        jnuePyciEk9aABf86M+aIMJZWk8qEOPqjWd9l1EsoSXmxf1x9NjWExvGPAdY0bgUR9m9gj
        QkgxEbItVIkewPyATZO/zjrwntHys8o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680098529;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0v7smsUOkD+0PDWZRSps2dW8wIjUlqektUnRtiqndwY=;
        b=iU6ws4hZnGFp9de3bINqs+L2zex2gzAkj9c1srM1RHqHc/2cWdg0eFSfdyiFGZmZRYPdNJ
        g90hJm/Ot2XsspBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 666DE138FF;
        Wed, 29 Mar 2023 14:02:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id XVoMDOFEJGSkJwAAMHmgww
        (envelope-from <farosas@suse.de>); Wed, 29 Mar 2023 14:02:09 +0000
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
Subject: Re: [PATCH-for-8.0 v2 3/3] softmmu: Restore use of CPU watchpoint
 for all accelerators
In-Reply-To: <20230328173117.15226-4-philmd@linaro.org>
References: <20230328173117.15226-1-philmd@linaro.org>
 <20230328173117.15226-4-philmd@linaro.org>
Date:   Wed, 29 Mar 2023 11:02:06 -0300
Message-ID: <87pm8ry7tt.fsf@suse.de>
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

> CPU watchpoints can be use by non-TCG accelerators.
>
> KVM uses them:
>
>   $ git grep CPUWatchpoint|fgrep kvm
>   target/arm/kvm64.c:1558:        CPUWatchpoint *wp =3D find_hw_watchpoin=
t(cs, debug_exit->far);
>   target/i386/kvm/kvm.c:5216:static CPUWatchpoint hw_watchpoint;
>   target/ppc/kvm.c:443:static CPUWatchpoint hw_watchpoint;
>   target/s390x/kvm/kvm.c:139:static CPUWatchpoint hw_watchpoint;
>
> See for example commit e4482ab7e3 ("target-arm: kvm - add support
> for HW assisted debug"):
>
>      This adds basic support for HW assisted debug. The ioctl interface
>      to KVM allows us to pass an implementation defined number of break
>      and watch point registers. [...]
>
> This partially reverts commit 2609ec2868e6c286e755a73b4504714a0296a.
>
> Fixes: 2609ec2868 ("softmmu: Extract watchpoint API from physmem.c")
> Signed-off-by: Philippe Mathieu-Daud=C3=A9 <philmd@linaro.org>

Reviewed-by: Fabiano Rosas <farosas@suse.de>
