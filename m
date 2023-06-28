Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 300B9741265
	for <lists+kvm@lfdr.de>; Wed, 28 Jun 2023 15:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbjF1N2j (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 28 Jun 2023 09:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbjF1N1N (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 28 Jun 2023 09:27:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D3563594
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 06:26:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B989961321
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 13:26:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1CBDCC433CB
        for <kvm@vger.kernel.org>; Wed, 28 Jun 2023 13:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1687958774;
        bh=GHZOdQQkpUmJE5OiM8MOrP1p5bmuxncIIJlsKmxCqzs=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=ay5Vk6YnD9QrafilMi8d/sh8nFtTd/Oz5ym+rzceXTZcxdBVOVJSNRo27Sfsm/SRG
         083djtNMYPSek0qXKp9E6LBFIeqftygm08/b2TvP0y95unrQy2EgzW9YBVOOwQiVKt
         pzU0TPG2GLO32dDeQ97ybGMPULvzesAEot13MxoeTu7XBkZ42liFhRUWs5gFF+Prwg
         aDPXDuFRo1XaDAtAqYtNYOKJZrIPh6vrpQeXlNR+o21qnNgttk5lRMbMBPY2rLa6OA
         JHCOqQvDVSpF0RvzCTWRauCNyBOhK65H0adf7XODL/I/L8nr6u7Y/9JBzt7n6nhO1X
         rZwqfSAIgr6hQ==
Received: by aws-us-west-2-korg-bugzilla-1.web.codeaurora.org (Postfix, from userid 48)
        id F0A0AC53BD4; Wed, 28 Jun 2023 13:26:13 +0000 (UTC)
From:   bugzilla-daemon@kernel.org
To:     kvm@vger.kernel.org
Subject: [Bug 217574] kvm_intel loads only after suspend
Date:   Wed, 28 Jun 2023 13:26:13 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Product: Virtualization
X-Bugzilla-Component: kvm
X-Bugzilla-Version: unspecified
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: blocking
X-Bugzilla-Who: drigoslkx@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P3
X-Bugzilla-Assigned-To: virtualization_kvm@kernel-bugs.osdl.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-217574-28872-LIdf1hiKJi@https.bugzilla.kernel.org/>
In-Reply-To: <bug-217574-28872@https.bugzilla.kernel.org/>
References: <bug-217574-28872@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D217574

--- Comment #7 from drigohighlander (drigoslkx@gmail.com) ---
Hi here is the outputs:

After bootup:
bash-5.2# rdmsr -a 0x48b |uniq
2007fff00000000
7fff00000000
2007fff00000000
7fff00000000

bash-5.2# cat /proc/cpuinfo |grep microcode |uniq
microcode       : 0x39

After suspend:
bash-5.2# rdmsr -a 0x48b |uniq
7fff00000000

bash-5.2# cat /proc/cpuinfo |grep microcode |uniq
microcode       : 0x39

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are watching the assignee of the bug.=
