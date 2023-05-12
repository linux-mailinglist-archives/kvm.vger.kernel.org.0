Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0022701255
	for <lists+kvm@lfdr.de>; Sat, 13 May 2023 01:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240474AbjELXMz (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 12 May 2023 19:12:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240423AbjELXMw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 12 May 2023 19:12:52 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6525D76A1
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:12:50 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-55a40d32a6bso115966117b3.2
        for <kvm@vger.kernel.org>; Fri, 12 May 2023 16:12:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683933169; x=1686525169;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tROVMxD+wvr9Y37+JVktpX9DU9Q3as8dJoLtqpcc4T0=;
        b=RALdbsOhos+ByDWKzKVujlqUCzIvZgeqF3NEA/CjV0hB7BxbA1EkfglTIgnc8JkeaA
         lOGPedhVRZ9D+4JdDT8/LSGndu6BdRa4QKqV7QdESgewzIewSJRJGSxxZXshm3kQCob+
         SmAikhVqOUlOSfDYM5yY+QLXvbZG9LH/ktp5slyQhnb1MHiJpLTHMuv/sIRAQQTkeilR
         h7Ul7reXi7I+fTMGGkNP5GukPAI6ejYA76YO35UVaIlKQiq/G3bM8+ZF/XVR4EJrijU8
         WBCfzZeHhH3npv4axO4nZ9eXUKsUlpk80yzNs5gKe1/jYdkCalilzgm7WysxOUqAqPly
         4gHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683933169; x=1686525169;
        h=cc:to:from:subject:message-id:mime-version:date:reply-to
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tROVMxD+wvr9Y37+JVktpX9DU9Q3as8dJoLtqpcc4T0=;
        b=h697e81Tm7eZHfLG6NYQtEAi6BkTftc4GIski8o4d3vp+p6oesilflw4N/qhx2FHNX
         4Q10Q1+aXxKNzfVsY1NEIUwFZDla3GDvP1Pvh/2GEct92buQ7nyjIyehXuC5iHxKXCiK
         lzrk7oOeS+Ayo3/v1H+hkSJrkvJXpFU0rESRDxUYiaw1SG9k46Sp2vKPB5lyO8RyOP/t
         VrI2pOQCDsxLSRBdmx6eYhtP9wjNJeF1a5g88XMKILDbWkf1HqYmq/LWoy6iCMyLNlPr
         C1xKZENdElTXRWXXujSllRMV5544rkzC/6e3mVpOwZSlITKCZs5x1qauwfjPM05X3f4U
         dgoA==
X-Gm-Message-State: AC+VfDymus6L4f3BehxsElMCE549y+Wa2E1bt7ymiNMa8rPonLn7CqAC
        YgGLLUug3/DMJSPkcxsHiEQbIL5m1yIQytlMPNCBFBPPvh2tSld2lZ/U0x3bTc3TRffgjcz4ot2
        uLbb8KjkU/3oJnZVBV0eHTLihlwBt79dSd1vY1rBsbJQKcOBmswZfIx4R6Q==
X-Google-Smtp-Source: ACHHUZ6o6mh7AYkUxxlfeMrJUR4eohO5DPS/K9FPNc/BUp4krpFBkxsvfYG+61Iz8/lUmBQRYYFk/m9fcHg=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a81:441a:0:b0:561:1d3b:af40 with SMTP id
 r26-20020a81441a000000b005611d3baf40mr2105258ywa.1.1683933169412; Fri, 12 May
 2023 16:12:49 -0700 (PDT)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 12 May 2023 16:10:27 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230512231026.799267-1-seanjc@google.com>
Subject: [ANNOUNCE / RFC] Periodic Upstream Call for KVM
From:   Sean Christopherson <seanjc@google.com>
To:     kvm@vger.kernel.org
Cc:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sagi Shahar <sagis@google.com>,
        Erdem Aktas <erdemaktas@google.com>,
        Anish Ghulati <aghulati@google.com>,
        Oliver Upton <oliver.upton@linux.dev>,
        James Houghton <jthoughton@google.com>,
        Anish Moorthy <amoorthy@google.com>,
        Ben Gardon <bgardon@google.com>,
        David Matlack <dmatlack@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Aaron Lewis <aaronlewis@google.com>,
        Ashish Kalra <ashish.kalra@amd.com>,
        Babu Moger <babu.moger@amd.com>, Chao Gao <chao.gao@intel.com>,
        Chao Peng <chao.p.peng@linux.intel.com>,
        Chenyi Qiang <chenyi.qiang@intel.com>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Emanuele Giuseppe Esposito <eesposit@redhat.com>,
        Gavin Shan <gshan@redhat.com>,
        Guang Zeng <guang.zeng@intel.com>,
        Hou Wenlong <houwenlong.hwl@antgroup.com>,
        Jiaxi Chen <jiaxi.chen@linux.intel.com>,
        Jim Mattson <jmattson@google.com>,
        Jing Liu <jing2.liu@intel.com>,
        Junaid Shahid <junaids@google.com>,
        Kai Huang <kai.huang@intel.com>,
        Leonardo Bras <leobras@redhat.com>,
        Like Xu <like.xu.linux@gmail.com>,
        Li RongQing <lirongqing@baidu.com>,
        "Maciej S . Szmigiero" <maciej.szmigiero@oracle.com>,
        Maxim Levitsky <mlevitsk@redhat.com>,
        Michael Roth <michael.roth@amd.com>,
        Michal Luczaj <mhal@rbox.co>,
        Mingwei Zhang <mizhang@google.com>,
        Nikunj A Dadhania <nikunj@amd.com>,
        Paul Durrant <pdurrant@amazon.com>,
        Peng Hao <flyingpenghao@gmail.com>,
        Peter Gonda <pgonda@google.com>, Peter Xu <peterx@redhat.com>,
        Robert Hoo <robert.hu@linux.intel.com>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Vipin Sharma <vipinsh@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Wei Wang <wei.w.wang@intel.com>,
        Xiaoyao Li <xiaoyao.li@intel.com>,
        Yu Zhang <yu.c.zhang@linux.intel.com>,
        Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        David Hildenbrand <david@redhat.com>,
        Fuad Tabba <tabba@google.com>,
        Isaku Yamahata <isaku.yamahata@gmail.com>,
        Qinglan Xiang <qinglan.xiang@intel.com>,
        Kai Svahn <kai.svahn@intel.com>,
        Margarita Maroto <margarita.maroto@intel.com>,
        Anil Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Nagareddy Reddy <nspreddy@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

I am "officially" announcing a Periodic Upstream Call for KVM, a.k.a. PUCK.
The intent of the PUCK is to provide a vehicle for having "in-person" technical
discussions of features, designs, problems, etc. that are cumbersome to discuss
asynchronously on-list, e.g. because something is too complex, too large, etc.

Exact details are TBD, and obviously can be adapted as needed.  Proposal:

  Frequency: Weekly
  Time:      Wednesday, 6:00am Pacific Time
  Duration:  60 minutes
  Software:  ???

My thinking for weekly versus fortnightly (every other week) is that we can always
cancel meetings if there are no agenda items, and bump down to fortnightly if we
are constantly canceling.  On the flip side, if we go with fortnightly, it'd be
more difficult to clear the backlog if PUCK gets booked out multiple sessions, and
PUCK would be less useful for discussing urgent issues.

As for the time, 6am Pacific Time was the least awful (and still quite awful IMO)
time I could find that gives the majority of the community a reasonable chance of
attending.  I know we have developers in at least the below time zones (and probably
more, though I don't think anyone works from Hawaii, and if someone does work from
Hawaii then they have nothing to complain about :-) ).

  PT   (6am)
  MT   (7am)
  CT   (8am)
  ET   (9am)
  WET  (2pm)
  CET  (3pm)
  EET  (4pm)
  EST  (5pm)
  CST  (9pm)
  NZST (1am)

The obvious alternative would be to invert the schedule and have the sync be in
the evening/night for Pacific Time, but to get 6am for ARM folks, we end up with:

  PT   (10pm)
  MT   (11pm)
  CT   (12pm)
  ET   (1am)
  WET  (6am)
  CET  (7am)
  EET  (8am)
  EST  (9am)
  CST  (1pm)
  NZST (5pm)

which is quite unreasonable for pretty much everyone based in the US.  Earlier
than 6am for WET is likewise unreasonable and will result in people not attending.
9pm for China is also unreasonable, but I hope that it's not completely ridiculous
and is doable enough that people can at least attend on an as-needed basis.  Sorry
Kai, as the sole representative from New Zealand, you get hosed :-(

Wednesday because holidays and (short) vacations most often land at the beginning
and end of the week.

60 minutes because I'm not waking up at dawn for anything less, and anything
more will likely have dimishing returns, especially for folks on the edges of
the time zone table.

Lastly, the big unknown is which video communication software to use.  My default
is obviously Google Meet, but I've been told that Meet is unusable in some
countries. :-/  My only requirements (beyond basic, obvious functionality) are
that (a) there's a web interface (no install required) and that (b) the calls can
be recorded.

To kick things off, I am leaning toward a "launch" date of May 24th (Pacific),
with KVM guest private mem (a.k.a. UPM) as the first topic.

Please chime in with thoughts and ideas!


P.S. This is an open invite, feel free to forward at will.  The Cc list is by no
means intended to be definitive.
