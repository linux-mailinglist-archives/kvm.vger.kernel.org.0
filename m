Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5552E258ABA
	for <lists+kvm@lfdr.de>; Tue,  1 Sep 2020 10:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgIAIvJ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 1 Sep 2020 04:51:09 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:54998 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727009AbgIAIvH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 1 Sep 2020 04:51:07 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 7EF4252195;
        Tue,  1 Sep 2020 08:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-transfer-encoding:content-type:content-type:mime-version
        :x-mailer:message-id:date:date:subject:subject:from:from
        :received:received:received; s=mta-01; t=1598950263; x=
        1600764664; bh=37Yh5D7JEPfFvtv3ty88W3/gXeYzg5RQpICbz2I0pl4=; b=u
        OHw4dZVMZd+gUrTLm30MagqH61liwQbJW65UpxCaEyHuGbOtkvwQTolKx8QSxBAP
        Ro3gjNXUBTUokXryVa06+y+Vc4OHpdnMRoP1/tf/DLHwMnnK5aN0Eob14FQgA2q/
        sKM+pPu1806zGyZJmDXGmwpkxoA2K0a1PM6cgl4bmY=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Bj02x__pdgCY; Tue,  1 Sep 2020 11:51:03 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id F0ECB5141E;
        Tue,  1 Sep 2020 11:51:03 +0300 (MSK)
Received: from localhost (172.17.204.212) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Tue, 1 Sep
 2020 11:51:03 +0300
From:   Roman Bolshakov <r.bolshakov@yadro.com>
To:     <kvm@vger.kernel.org>
CC:     Thomas Huth <thuth@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
Subject: [kvm-unit-tests PATCH v2 00/10] Add support for generic ELF cross-compiler
Date:   Tue, 1 Sep 2020 11:50:46 +0300
Message-ID: <20200901085056.33391-1-r.bolshakov@yadro.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.17.204.212]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The series introduces a way to build the tests with generic i686-pc-elf
and x86_64-pc-elf GCC target. It also fixes build on macOS and
introduces a way to specify enhanced getopt. Build instructions for macOS
have been updated to reflect the changes.

Changes since v1:
 - Detect if -Wa,--divide is really needed to avoid compilation failure
   on clang-10 (Thomas)
 - Add Travis CI jobs for x86/osx/TCG and bionic/clang-10 (Thomas)
   (https://travis-ci.com/github/roolebo/kvm-unit-tests/builds/182213034)
 - Added one portable format macro for new code (Thomas)

Roman Bolshakov (10):
  x86: Makefile: Allow division on x86_64-elf binutils
  x86: Replace instruction prefixes with spaces
  x86: Makefile: Fix linkage of realmode on x86_64-elf binutils
  lib: Bundle debugreg.h from the kernel
  lib: x86: Use portable format macros for uint32_t
  configure: Add an option to specify getopt
  README: Update build instructions for macOS
  travis.yml: Add CI for macOS
  travis.yml: Change matrix keyword to jobs
  travis.yml: Add x86 build with clang 10

 .travis.yml            | 55 ++++++++++++++++++++++++++--
 README.macOS.md        | 71 +++++++++++++++++++++++++-----------
 configure              | 25 +++++++++++++
 lib/pci.c              |  2 +-
 lib/x86/asm/debugreg.h | 81 ++++++++++++++++++++++++++++++++++++++++++
 run_tests.sh           |  2 +-
 x86/Makefile.common    |  6 +++-
 x86/asyncpf.c          |  2 +-
 x86/cstart.S           |  4 +--
 x86/cstart64.S         |  4 +--
 x86/emulator.c         | 38 ++++++++++----------
 x86/msr.c              |  3 +-
 x86/s3.c               |  2 +-
 13 files changed, 244 insertions(+), 51 deletions(-)
 create mode 100644 lib/x86/asm/debugreg.h

-- 
2.28.0

