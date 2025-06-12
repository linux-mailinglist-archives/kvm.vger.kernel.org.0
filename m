Return-Path: <kvm+bounces-49309-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C9F6BAD7CB2
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 22:56:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7BB791894B65
	for <lists+kvm@lfdr.de>; Thu, 12 Jun 2025 20:56:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E1102D8781;
	Thu, 12 Jun 2025 20:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="R3rciVig"
X-Original-To: kvm@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4BE2BE7D7
	for <kvm@vger.kernel.org>; Thu, 12 Jun 2025 20:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749761753; cv=none; b=ArKn/2bQMifCNGCT6ayF/r1sSSi5z0xm2Q66Q6FBhumzTcVKLQgKpeL4mtDQbtnSXSAgU8mJnxR3syKQOvyAYISpjtV14EVPIpaf5ukpCXTxQs4nBcJ41U9YNpu62xoQMCf/QX7ESxxNn9ZP471h695uF5REiv1pGvrU1zIGARE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749761753; c=relaxed/simple;
	bh=Ix1VneO6BZt9n5Bcwm+7eonz+fOdiRor/9qIYDBo1mU=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=iKC+uyiU/dJ6dAzg+intHQr6/Fsa0QoeYPViCEPfF3/FKh5IkPtySAwaMhruDxHrMveIUlJ1gWBtoSL0SwphkteLcB6M33W8daXJfCk8h1to2hZ6BzumuBQ3uxwhc+MiwspNMifWQ5XcCkOQoc8QSqrM15inN2F/4eLW7Qosoz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=R3rciVig; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749761749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1FocXpixhNfGu39v6/cNellGNuGl2w0TLDZKjW+TAPA=;
	b=R3rciVigu5rJv15rJ45qqVZ7Etp3nJfFnwQZ6W8CIRCkpho2EN8lvojZ3eRM18DKCrjzyk
	yElsZQMdXJsYmoGRWpCITmZwH0wkmGp8I+SKxZ4IISDi/qdewl9xiY75+DrDFjKjBvpvau
	Tz9NxOGDJWZmnsOrv/oLNOr33An3tDM=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-149-nLKtXSULOVO2NMNDAYlmyA-1; Thu,
 12 Jun 2025 16:55:43 -0400
X-MC-Unique: nLKtXSULOVO2NMNDAYlmyA-1
X-Mimecast-MFC-AGG-ID: nLKtXSULOVO2NMNDAYlmyA_1749761738
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2055F195608B;
	Thu, 12 Jun 2025 20:55:36 +0000 (UTC)
Received: from jsnow-thinkpadp16vgen1.westford.csb (unknown [10.22.80.54])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A830F1956050;
	Thu, 12 Jun 2025 20:54:53 +0000 (UTC)
From: John Snow <jsnow@redhat.com>
To: qemu-devel@nongnu.org
Cc: Joel Stanley <joel@jms.id.au>,
	Yi Liu <yi.l.liu@intel.com>,
	=?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
	Helge Deller <deller@gmx.de>,
	Marcel Apfelbaum <marcel.apfelbaum@gmail.com>,
	Andrew Jeffery <andrew@codeconstruct.com.au>,
	Fabiano Rosas <farosas@suse.de>,
	Alexander Bulekov <alxndr@bu.edu>,
	Darren Kenny <darren.kenny@oracle.com>,
	Leif Lindholm <leif.lindholm@oss.qualcomm.com>,
	=?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
	Ed Maste <emaste@freebsd.org>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Warner Losh <imp@bsdimp.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Tyrone Ting <kfting@nuvoton.com>,
	Eric Blake <eblake@redhat.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	Troy Lee <leetroy@gmail.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
	Michael Roth <michael.roth@amd.com>,
	Laurent Vivier <laurent@vivier.eu>,
	Ani Sinha <anisinha@redhat.com>,
	Weiwei Li <liwei1518@gmail.com>,
	John Snow <jsnow@redhat.com>,
	Eric Farman <farman@linux.ibm.com>,
	Steven Lee <steven_lee@aspeedtech.com>,
	Brian Cain <brian.cain@oss.qualcomm.com>,
	Li-Wen Hsu <lwhsu@freebsd.org>,
	Jamin Lin <jamin_lin@aspeedtech.com>,
	qemu-s390x@nongnu.org,
	Vladimir Sementsov-Ogievskiy <vsementsov@yandex-team.ru>,
	qemu-block@nongnu.org,
	Bernhard Beschow <shentey@gmail.com>,
	=?UTF-8?q?Cl=C3=A9ment=20Mathieu--Drif?= <clement.mathieu--drif@eviden.com>,
	Maksim Davydov <davydov-max@yandex-team.ru>,
	Niek Linnenbank <nieklinnenbank@gmail.com>,
	=?UTF-8?q?Herv=C3=A9=20Poussineau?= <hpoussin@reactos.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Paul Durrant <paul@xen.org>,
	Manos Pitsidianakis <manos.pitsidianakis@linaro.org>,
	Jagannathan Raman <jag.raman@oracle.com>,
	Igor Mitsyanko <i.mitsyanko@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Markus Armbruster <armbru@redhat.com>,
	Pierrick Bouvier <pierrick.bouvier@linaro.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Anton Johansson <anjo@rev.ng>,
	Peter Maydell <peter.maydell@linaro.org>,
	Cleber Rosa <crosa@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Yanan Wang <wangyanan55@huawei.com>,
	qemu-arm@nongnu.org,
	Hao Wu <wuhaotsh@google.com>,
	Mads Ynddal <mads@ynddal.dk>,
	Sriram Yagnaraman <sriram.yagnaraman@ericsson.com>,
	qemu-riscv@nongnu.org,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Rolnik <mrolnik@gmail.com>,
	Zhao Liu <zhao1.liu@intel.com>,
	Alessandro Di Federico <ale@rev.ng>,
	Thomas Huth <thuth@redhat.com>,
	Antony Pavlov <antonynpavlov@gmail.com>,
	Jiaxun Yang <jiaxun.yang@flygoat.com>,
	Hanna Reitz <hreitz@redhat.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Marcelo Tosatti <mtosatti@redhat.com>,
	Nina Schoetterl-Glausch <nsg@linux.ibm.com>,
	Daniel Henrique Barboza <danielhb413@gmail.com>,
	Qiuhao Li <Qiuhao.Li@outlook.com>,
	Hyman Huang <yong.huang@smartx.com>,
	=?UTF-8?q?Daniel=20P=2E=20Berrang=C3=A9?= <berrange@redhat.com>,
	Magnus Damm <magnus.damm@gmail.com>,
	qemu-rust@nongnu.org,
	Bandan Das <bsd@redhat.com>,
	Strahinja Jankovic <strahinja.p.jankovic@gmail.com>,
	Mark Cave-Ayland <mark.cave-ayland@ilande.co.uk>,
	=?UTF-8?q?Philippe=20Mathieu-Daud=C3=A9?= <philmd@linaro.org>,
	kvm@vger.kernel.org,
	Fam Zheng <fam@euphon.net>,
	Jia Liu <proljc@gmail.com>,
	=?UTF-8?q?Marc-Andr=C3=A9=20Lureau?= <marcandre.lureau@redhat.com>,
	Alistair Francis <alistair@alistair23.me>,
	Subbaraya Sundeep <sundeep.lkml@gmail.com>,
	Kyle Evans <kevans@freebsd.org>,
	Song Gao <gaosong@loongson.cn>,
	Alexandre Iooss <erdnaxe@crans.org>,
	Aurelien Jarno <aurelien@aurel32.net>,
	Liu Zhiwei <zhiwei_liu@linux.alibaba.com>,
	Peter Xu <peterx@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	BALATON Zoltan <balaton@eik.bme.hu>,
	Elena Ufimtseva <elena.ufimtseva@oracle.com>,
	"Edgar E. Iglesias" <edgar.iglesias@gmail.com>,
	=?UTF-8?q?Fr=C3=A9d=C3=A9ric=20Barrat?= <fbarrat@linux.ibm.com>,
	qemu-ppc@nongnu.org,
	Radoslaw Biernacki <rad@semihalf.com>,
	Beniamino Galvani <b.galvani@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Richard Henderson <richard.henderson@linaro.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Eduardo Habkost <eduardo@habkost.net>,
	Ahmed Karaman <ahmedkhaledkaraman@gmail.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Mahmoud Mandour <ma.mandourr@gmail.com>,
	Harsh Prateek Bora <harshpb@linux.ibm.com>
Subject: [PATCH v2 00/12] Python: Fix 'make check-dev' and modernize to 3.9+
Date: Thu, 12 Jun 2025 16:54:38 -0400
Message-ID: <20250612205451.1177751-1-jsnow@redhat.com>
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

This series does a couple things that I'll probably end up splitting out=0D
into smaller series if history is any guide, but either way, here it=0D
goes:=0D
=0D
A) Convert qemu.git/python/ to a PEP517/pyproject.toml=0D
package. Ultimately this means deleting setup.py and fully migrating to=0D
newer python infrastructure. I think this should be safe to do by now,=0D
but admittedly I am not *confident* as it relies on setuptools versions=0D
in the wild, not python versions. My motivation for trying it is to fix=0D
"make check-dev", which has been broken for the last two Fedora releases=0D
under newer setuptools which have started removing support for the=0D
pre-PEP517 packaging formats, which will only continue to get worse from=0D
here on out.=0D
=0D
B) Sync changes from the qemu.qmp package back over to qemu.git. I know=0D
I need to decouple this badly, but in order to do so, I need to make=0D
sure they're synchronized to be assured that the switch to the=0D
standalone version won't break anything, so this is a necessary=0D
step. It's happening here because of the 3.6+ compat crud we are still=0D
carrying in qemu.git that has since been removed from the standalone=0D
library.=0D
=0D
C) Move us to 3.9+ style type hints. They are deprecated in 3.9, and=0D
*could* be removed at any time. I figured now was a good time as any to=0D
get rid of them before they become a problem randomly some day in the=0D
future.=0D
=0D
D) Update the mypy configuration to check under multiple Python versions=0D
more effectively and thoroughly.=0D
=0D
Whew.=0D
=0D
v2:=0D
 - Perform the 3.9+ syntax conversion using automated tooling instead=0D
 - Correct illegal escape sequences (pyupgrade whines otherwise)=0D
 - Use the correct shebang for all python scripts in tree=0D
 - Remove asterisk imports from scripts/codeconverter=0D
 - rebased on origin/master=0D
=0D
John Snow (12):=0D
  python: convert packages to PEP517/pyproject.toml=0D
  python: update pylint ignores=0D
  python: sync changes from external qemu.qmp package=0D
  python: update shebangs to standard, using /usr/bin/env=0D
  python: fix illegal escape sequences=0D
  python: upgrade to python3.9+ syntax=0D
  fixup=0D
  python: further 3.9+ syntax upgrades=0D
  python: update mkvenv to type-check under different python versions=0D
  python: remove version restriction for mypy=0D
  scripts/codeconverter: remove unused code=0D
  scripts/codeconverter: remove * imports=0D
=0D
 docs/conf.py                                  |  13 +-=0D
 docs/sphinx/compat.py                         |  12 +-=0D
 docs/sphinx/dbusdoc.py                        |  28 +-=0D
 docs/sphinx/dbusdomain.py                     |  39 +--=0D
 docs/sphinx/dbusparser.py                     |   4 +-=0D
 docs/sphinx/depfile.py                        |  11 +-=0D
 docs/sphinx/fakedbusdoc.py                    |   5 +-=0D
 docs/sphinx/hxtool.py                         |   7 +-=0D
 docs/sphinx/kerneldoc.py                      |   8 +-=0D
 docs/sphinx/qapi_domain.py                    |  81 +++---=0D
 docs/sphinx/qapidoc.py                        |  29 +-=0D
 docs/sphinx/qapidoc_legacy.py                 |   1 -=0D
 docs/sphinx/qmp_lexer.py                      |   7 +-=0D
 python/README.rst                             |  33 ++-=0D
 .gitlab-ci.d/check-dco.py                     |   9 +-=0D
 .gitlab-ci.d/check-patch.py                   |   7 +-=0D
 .gitlab-ci.d/check-units.py                   |   8 +-=0D
 python/Makefile                               |  18 +-=0D
 python/pyproject.toml                         |  10 +=0D
 python/qemu/machine/console_socket.py         |   6 +-=0D
 python/qemu/machine/machine.py                |  34 +--=0D
 python/qemu/machine/qtest.py                  |  13 +-=0D
 python/qemu/qmp/error.py                      |   7 +-=0D
 python/qemu/qmp/events.py                     |  72 +++--=0D
 python/qemu/qmp/legacy.py                     |  31 +-=0D
 python/qemu/qmp/message.py                    |  38 +--=0D
 python/qemu/qmp/models.py                     |  17 +-=0D
 python/qemu/qmp/protocol.py                   | 179 +++++++-----=0D
 python/qemu/qmp/qmp_client.py                 | 147 +++++++---=0D
 python/qemu/qmp/qmp_shell.py                  | 182 ++++++++----=0D
 python/qemu/qmp/qmp_tui.py                    |  55 ++--=0D
 python/qemu/qmp/util.py                       | 116 +-------=0D
 python/qemu/utils/accel.py                    |   6 +-=0D
 python/qemu/utils/qemu_ga_client.py           |  13 +-=0D
 python/qemu/utils/qom_common.py               |  15 +-=0D
 python/qemu/utils/qom_fuse.py                 |  12 +-=0D
 python/scripts/mkvenv.py                      |  40 ++-=0D
 python/setup.cfg                              |   6 +-=0D
 python/setup.py                               |  40 ---=0D
 python/tests/minreqs.txt                      |   2 +-=0D
 python/tests/protocol.py                      |  11 +-=0D
 roms/edk2-build.py                            |  19 +-=0D
 scripts/analyse-9p-simpletrace.py             |   2 +=0D
 scripts/analyse-locks-simpletrace.py          |   5 +-=0D
 scripts/analyze-migration.py                  |  48 ++--=0D
 scripts/block-coroutine-wrapper.py            |   4 +-=0D
 scripts/check_sparse.py                       |   9 +-=0D
 scripts/ci/gitlab-pipeline-status             |   4 +-=0D
 .../codeconverter/codeconverter/patching.py   |  76 ++---=0D
 .../codeconverter/codeconverter/qom_macros.py |  98 +++++--=0D
 .../codeconverter/qom_type_info.py            |  86 ++++--=0D
 .../codeconverter/codeconverter/regexps.py    |   5 +-=0D
 .../codeconverter/test_patching.py            |   6 +-=0D
 .../codeconverter/test_regexps.py             |  33 ++-=0D
 scripts/codeconverter/codeconverter/utils.py  |  10 +-=0D
 scripts/codeconverter/converter.py            |  16 +-=0D
 scripts/compare-machine-types.py              |  49 ++--=0D
 scripts/coverage/compare_gcov_json.py         |   7 +-=0D
 scripts/cpu-x86-uarch-abi.py                  |   6 +-=0D
 scripts/decodetree.py                         |  12 +-=0D
 scripts/device-crash-test                     |  18 +-=0D
 scripts/dump-guest-memory.py                  |   5 +-=0D
 scripts/feature_to_c.py                       |   7 +-=0D
 scripts/kvm/kvm_flightrecorder                |   7 +-=0D
 scripts/kvm/vmxcap                            |   6 +-=0D
 scripts/meson-buildoptions.py                 |   3 +-=0D
 scripts/minikconf.py                          |  13 +-=0D
 scripts/modinfo-collect.py                    |   7 +-=0D
 scripts/modinfo-generate.py                   |   4 +-=0D
 scripts/modules/module_block.py               |   5 +-=0D
 scripts/mtest2make.py                         |   8 +-=0D
 scripts/oss-fuzz/minimize_qtest_trace.py      |  18 +-=0D
 scripts/oss-fuzz/output_reproducer.py         |  18 +-=0D
 .../oss-fuzz/reorder_fuzzer_qtest_trace.py    |   6 +-=0D
 scripts/performance/dissect.py                |   2 +-=0D
 scripts/performance/topN_callgrind.py         |   2 +-=0D
 scripts/performance/topN_perf.py              |   2 +-=0D
 scripts/probe-gdb-support.py                  |   4 +-=0D
 scripts/python_qmp_updater.py                 |   1 +=0D
 scripts/qapi-gen.py                           |   1 +=0D
 scripts/qapi/commands.py                      |  13 +-=0D
 scripts/qapi/common.py                        |  61 ++--=0D
 scripts/qapi/error.py                         |   1 -=0D
 scripts/qapi/events.py                        |   8 +-=0D
 scripts/qapi/expr.py                          |  21 +-=0D
 scripts/qapi/features.py                      |   2 +-=0D
 scripts/qapi/gen.py                           |  14 +-=0D
 scripts/qapi/introspect.py                    |  42 ++-=0D
 scripts/qapi/parser.py                        |  44 ++-=0D
 scripts/qapi/schema.py                        | 271 +++++++++---------=0D
 scripts/qapi/source.py                        |  10 +-=0D
 scripts/qapi/types.py                         |  20 +-=0D
 scripts/qapi/visit.py                         |  14 +-=0D
 scripts/qcow2-to-stdout.py                    |   8 +-=0D
 scripts/qemu-gdb.py                           |  13 +-=0D
 scripts/qemu-plugin-symbols.py                |   4 +-=0D
 scripts/qemu-stamp.py                         |   1 +=0D
 scripts/qemu-trace-stap                       |   1 -=0D
 scripts/qemugdb/aio.py                        |   1 +=0D
 scripts/qemugdb/coroutine.py                  |   1 +=0D
 scripts/qemugdb/mtree.py                      |   1 +=0D
 scripts/qemugdb/tcg.py                        |   2 +-=0D
 scripts/qemugdb/timers.py                     |   2 +-=0D
 scripts/qmp/qemu-ga-client                    |   1 +=0D
 scripts/qmp/qmp                               |   1 +=0D
 scripts/qmp/qmp-shell                         |   1 +=0D
 scripts/qmp/qmp-shell-wrap                    |   1 +=0D
 scripts/qmp/qom-fuse                          |   1 +=0D
 scripts/qmp/qom-get                           |   1 +=0D
 scripts/qmp/qom-list                          |   1 +=0D
 scripts/qmp/qom-set                           |   1 +=0D
 scripts/qmp/qom-tree                          |   1 +=0D
 scripts/qom-cast-macro-clean-cocci-gen.py     |   3 +-=0D
 scripts/render_block_graph.py                 |  28 +-=0D
 scripts/replay-dump.py                        |  10 +-=0D
 scripts/rust/rustc_args.py                    |  10 +-=0D
 scripts/shaderinclude.py                      |   4 +-=0D
 scripts/signrom.py                            |   3 +-=0D
 scripts/simplebench/bench-backup.py           |   9 +-=0D
 scripts/simplebench/bench-example.py          |   4 +-=0D
 scripts/simplebench/bench_block_job.py        |   9 +-=0D
 scripts/simplebench/bench_prealloc.py         |  10 +-=0D
 scripts/simplebench/bench_write_req.py        |   5 +-=0D
 scripts/simplebench/img_bench_templater.py    |  10 +-=0D
 scripts/simplebench/results_to_text.py        |   4 +-=0D
 scripts/simplebench/simplebench.py            |   2 +-=0D
 scripts/simplebench/table_templater.py        |   4 +-=0D
 scripts/simpletrace.py                        |  16 +-=0D
 scripts/symlink-install-tree.py               |   3 +-=0D
 scripts/tracetool.py                          |   5 +-=0D
 scripts/tracetool/__init__.py                 |  11 +-=0D
 scripts/tracetool/backend/__init__.py         |   2 -=0D
 scripts/tracetool/backend/dtrace.py           |   2 -=0D
 scripts/tracetool/backend/ftrace.py           |   2 -=0D
 scripts/tracetool/backend/log.py              |   2 -=0D
 scripts/tracetool/backend/simple.py           |   2 -=0D
 scripts/tracetool/backend/syslog.py           |   2 -=0D
 scripts/tracetool/backend/ust.py              |   2 -=0D
 scripts/tracetool/format/__init__.py          |   2 -=0D
 scripts/tracetool/format/c.py                 |   2 -=0D
 scripts/tracetool/format/d.py                 |   5 +-=0D
 scripts/tracetool/format/h.py                 |   2 -=0D
 scripts/tracetool/format/log_stap.py          |   3 +-=0D
 scripts/tracetool/format/simpletrace_stap.py  |   3 +-=0D
 scripts/tracetool/format/stap.py              |   2 -=0D
 scripts/tracetool/format/ust_events_c.py      |   2 -=0D
 scripts/tracetool/format/ust_events_h.py      |   2 -=0D
 scripts/u2f-setup-gen.py                      |  15 +-=0D
 scripts/undefsym.py                           |   3 +-=0D
 scripts/userfaultfd-wrlat.py                  |  10 +-=0D
 scripts/vmstate-static-checker.py             |   1 +=0D
 scripts/xml-preprocess-test.py                |   3 +-=0D
 scripts/xml-preprocess.py                     |   4 +-=0D
 target/hexagon/gen_analyze_funcs.py           |   3 -=0D
 target/hexagon/gen_decodetree.py              |   9 +-=0D
 target/hexagon/gen_helper_funcs.py            |   3 -=0D
 target/hexagon/gen_helper_protos.py           |   4 +-=0D
 target/hexagon/gen_idef_parser_funcs.py       |   4 -=0D
 target/hexagon/gen_op_attribs.py              |   6 +-=0D
 target/hexagon/gen_opcodes_def.py             |   6 +-=0D
 target/hexagon/gen_printinsn.py               |   5 +-=0D
 target/hexagon/gen_tcg_func_table.py          |   6 +-=0D
 target/hexagon/gen_tcg_funcs.py               |   3 -=0D
 target/hexagon/gen_trans_funcs.py             |   8 +-=0D
 target/hexagon/hex_common.py                  |  15 +-=0D
 tests/docker/docker.py                        |  37 ++-=0D
 tests/functional/aspeed.py                    |   4 +-=0D
 tests/functional/qemu_test/__init__.py        |  30 +-=0D
 tests/functional/qemu_test/archive.py         |   2 +-=0D
 tests/functional/qemu_test/asset.py           |  10 +-=0D
 tests/functional/qemu_test/decorators.py      |   1 +=0D
 tests/functional/qemu_test/linuxkernel.py     |   5 +-=0D
 tests/functional/qemu_test/ports.py           |   3 +-=0D
 tests/functional/qemu_test/testcase.py        |   2 +-=0D
 tests/functional/qemu_test/tuxruntest.py      |  12 +-=0D
 tests/functional/qemu_test/uncompress.py      |   4 +-=0D
 tests/functional/replay_kernel.py             |   7 +-=0D
 tests/functional/reverse_debugging.py         |   5 +-=0D
 .../functional/test_aarch64_aspeed_ast2700.py |   9 +-=0D
 .../test_aarch64_aspeed_ast2700fc.py          |   9 +-=0D
 tests/functional/test_aarch64_imx8mp_evk.py   |   4 +-=0D
 tests/functional/test_aarch64_raspi3.py       |   2 +-=0D
 tests/functional/test_aarch64_raspi4.py       |   7 +-=0D
 tests/functional/test_aarch64_replay.py       |   4 +-=0D
 .../functional/test_aarch64_reverse_debug.py  |   2 +-=0D
 tests/functional/test_aarch64_rme_sbsaref.py  |   8 +-=0D
 tests/functional/test_aarch64_rme_virt.py     |  11 +-=0D
 tests/functional/test_aarch64_sbsaref.py      |   9 +-=0D
 .../functional/test_aarch64_sbsaref_alpine.py |   8 +-=0D
 .../test_aarch64_sbsaref_freebsd.py           |   8 +-=0D
 tests/functional/test_aarch64_smmu.py         |   8 +-=0D
 tests/functional/test_aarch64_tcg_plugins.py  |   4 +-=0D
 tests/functional/test_aarch64_tuxrun.py       |   1 +=0D
 tests/functional/test_aarch64_virt.py         |  11 +-=0D
 tests/functional/test_aarch64_virt_gpu.py     |   7 +-=0D
 tests/functional/test_aarch64_xlnx_versal.py  |   3 +-=0D
 tests/functional/test_acpi_bits.py            |  21 +-=0D
 tests/functional/test_alpha_clipper.py        |   2 +-=0D
 tests/functional/test_arm_aspeed_ast1030.py   |   7 +-=0D
 tests/functional/test_arm_aspeed_ast2500.py   |   2 +-=0D
 tests/functional/test_arm_aspeed_ast2600.py   |  11 +-=0D
 tests/functional/test_arm_aspeed_bletchley.py |   2 +-=0D
 tests/functional/test_arm_aspeed_palmetto.py  |   2 +-=0D
 tests/functional/test_arm_aspeed_rainier.py   |   3 +-=0D
 tests/functional/test_arm_aspeed_romulus.py   |   2 +-=0D
 .../functional/test_arm_aspeed_witherspoon.py |   2 +-=0D
 tests/functional/test_arm_bflt.py             |   8 +-=0D
 tests/functional/test_arm_bpim2u.py           |  10 +-=0D
 tests/functional/test_arm_canona1100.py       |   3 +-=0D
 tests/functional/test_arm_collie.py           |   2 +-=0D
 tests/functional/test_arm_cubieboard.py       |  10 +-=0D
 tests/functional/test_arm_emcraft_sf2.py      |   7 +-=0D
 tests/functional/test_arm_integratorcp.py     |  12 +-=0D
 tests/functional/test_arm_microbit.py         |   8 +-=0D
 tests/functional/test_arm_orangepi.py         |  11 +-=0D
 tests/functional/test_arm_quanta_gsj.py       |   9 +-=0D
 tests/functional/test_arm_raspi2.py           |   7 +-=0D
 tests/functional/test_arm_smdkc210.py         |   2 +-=0D
 tests/functional/test_arm_stellaris.py        |   8 +-=0D
 tests/functional/test_arm_sx1.py              |   2 +-=0D
 tests/functional/test_arm_tuxrun.py           |   1 +=0D
 tests/functional/test_arm_vexpress.py         |   2 +-=0D
 tests/functional/test_arm_virt.py             |   3 +-=0D
 tests/functional/test_avr_mega2560.py         |   2 +-=0D
 tests/functional/test_avr_uno.py              |   2 +-=0D
 tests/functional/test_cpu_queries.py          |   1 +=0D
 tests/functional/test_empty_cpu_model.py      |   1 +=0D
 tests/functional/test_hppa_seabios.py         |   4 +-=0D
 tests/functional/test_i386_tuxrun.py          |   1 +=0D
 tests/functional/test_intel_iommu.py          |   6 +-=0D
 tests/functional/test_linux_initrd.py         |   2 +-=0D
 tests/functional/test_loongarch64_virt.py     |  10 +-=0D
 tests/functional/test_m68k_mcf5208evb.py      |   2 +-=0D
 tests/functional/test_m68k_nextcube.py        |   8 +-=0D
 tests/functional/test_m68k_q800.py            |   3 +-=0D
 tests/functional/test_m68k_tuxrun.py          |   1 +=0D
 tests/functional/test_mem_addr_space.py       |   4 +-=0D
 tests/functional/test_memlock.py              |   9 +-=0D
 .../functional/test_microblaze_s3adsp1800.py  |   9 +-=0D
 tests/functional/test_mips64_malta.py         |   2 +-=0D
 tests/functional/test_mips64_tuxrun.py        |   1 +=0D
 tests/functional/test_mips64el_fuloong2e.py   |  11 +-=0D
 tests/functional/test_mips64el_loongson3v.py  |   8 +-=0D
 tests/functional/test_mips64el_malta.py       |  17 +-=0D
 tests/functional/test_mips64el_tuxrun.py      |   1 +=0D
 tests/functional/test_mips_malta.py           |   8 +-=0D
 tests/functional/test_mips_tuxrun.py          |   1 +=0D
 tests/functional/test_mipsel_malta.py         |  11 +-=0D
 tests/functional/test_mipsel_tuxrun.py        |   1 +=0D
 tests/functional/test_multiprocess.py         |  10 +-=0D
 tests/functional/test_netdev_ethtool.py       |   5 +-=0D
 tests/functional/test_or1k_sim.py             |   2 +-=0D
 tests/functional/test_pc_cpu_hotplug_props.py |   1 +=0D
 tests/functional/test_ppc64_e500.py           |   7 +-=0D
 tests/functional/test_ppc64_hv.py             |  16 +-=0D
 tests/functional/test_ppc64_mac99.py          |   8 +-=0D
 tests/functional/test_ppc64_powernv.py        |   4 +-=0D
 tests/functional/test_ppc64_pseries.py        |   4 +-=0D
 tests/functional/test_ppc64_reverse_debug.py  |   2 +-=0D
 tests/functional/test_ppc64_tuxrun.py         |   3 +-=0D
 tests/functional/test_ppc_40p.py              |  10 +-=0D
 tests/functional/test_ppc_74xx.py             |   4 +-=0D
 tests/functional/test_ppc_amiga.py            |   3 +-=0D
 tests/functional/test_ppc_bamboo.py           |   9 +-=0D
 tests/functional/test_ppc_mac.py              |   2 +-=0D
 tests/functional/test_ppc_mpc8544ds.py        |   3 +-=0D
 tests/functional/test_ppc_sam460ex.py         |   7 +-=0D
 tests/functional/test_ppc_tuxrun.py           |   1 +=0D
 tests/functional/test_ppc_virtex_ml507.py     |   3 +-=0D
 tests/functional/test_riscv32_tuxrun.py       |   1 +=0D
 tests/functional/test_riscv64_tuxrun.py       |   1 +=0D
 tests/functional/test_riscv_opensbi.py        |   4 +-=0D
 tests/functional/test_rx_gdbsim.py            |  10 +-=0D
 tests/functional/test_s390x_ccw_virtio.py     |   9 +-=0D
 tests/functional/test_s390x_topology.py       |  11 +-=0D
 tests/functional/test_s390x_tuxrun.py         |   1 +=0D
 tests/functional/test_sh4_r2d.py              |   2 +-=0D
 tests/functional/test_sh4_tuxrun.py           |   1 +=0D
 tests/functional/test_sh4eb_r2d.py            |   7 +-=0D
 tests/functional/test_sparc64_sun4u.py        |   3 +-=0D
 tests/functional/test_sparc64_tuxrun.py       |   1 +=0D
 tests/functional/test_sparc_sun4m.py          |   2 +-=0D
 tests/functional/test_virtio_balloon.py       |  10 +-=0D
 tests/functional/test_virtio_gpu.py           |  14 +-=0D
 tests/functional/test_virtio_version.py       |   1 +=0D
 tests/functional/test_x86_64_hotplug_blk.py   |   6 +-=0D
 tests/functional/test_x86_64_hotplug_cpu.py   |   6 +-=0D
 tests/functional/test_x86_64_kvm_xen.py       |   8 +-=0D
 tests/functional/test_x86_64_replay.py        |   4 +-=0D
 tests/functional/test_x86_64_reverse_debug.py |   2 +-=0D
 tests/functional/test_x86_64_tuxrun.py        |   1 +=0D
 .../functional/test_x86_cpu_model_versions.py |  13 +-=0D
 tests/functional/test_xtensa_lx60.py          |   2 +-=0D
 tests/guest-debug/run-test.py                 |   9 +-=0D
 tests/guest-debug/test_gdbstub.py             |  15 +-=0D
 tests/image-fuzzer/qcow2/fuzz.py              |   3 +-=0D
 tests/image-fuzzer/qcow2/layout.py            |  32 ++-=0D
 tests/image-fuzzer/runner.py                  |  19 +-=0D
 tests/lcitool/refresh                         |   6 +-=0D
 tests/migration-stress/guestperf-batch.py     |   1 +=0D
 tests/migration-stress/guestperf-plot.py      |   1 +=0D
 tests/migration-stress/guestperf.py           |   1 +=0D
 .../migration-stress/guestperf/comparison.py  |   3 +-=0D
 tests/migration-stress/guestperf/engine.py    |   8 +-=0D
 tests/migration-stress/guestperf/hardware.py  |   2 +-=0D
 tests/migration-stress/guestperf/plot.py      |   4 +-=0D
 tests/migration-stress/guestperf/progress.py  |   4 +-=0D
 tests/migration-stress/guestperf/report.py    |   9 +-=0D
 tests/migration-stress/guestperf/scenario.py  |   2 +-=0D
 tests/migration-stress/guestperf/shell.py     |  18 +-=0D
 tests/migration-stress/guestperf/timings.py   |   4 +-=0D
 tests/qapi-schema/test-qapi.py                |   2 +-=0D
 tests/qemu-iotests/030                        |   6 +-=0D
 tests/qemu-iotests/040                        |   6 +-=0D
 tests/qemu-iotests/041                        |   7 +-=0D
 tests/qemu-iotests/044                        |  11 +-=0D
 tests/qemu-iotests/045                        |  10 +-=0D
 tests/qemu-iotests/055                        |   4 +-=0D
 tests/qemu-iotests/056                        |   6 +-=0D
 tests/qemu-iotests/057                        |   5 +-=0D
 tests/qemu-iotests/065                        |  10 +-=0D
 tests/qemu-iotests/093                        |   9 +-=0D
 tests/qemu-iotests/096                        |   4 +-=0D
 tests/qemu-iotests/118                        |   4 +-=0D
 tests/qemu-iotests/124                        |   8 +-=0D
 tests/qemu-iotests/129                        |   2 +=0D
 tests/qemu-iotests/132                        |   3 +-=0D
 tests/qemu-iotests/136                        |   4 +-=0D
 tests/qemu-iotests/139                        |   3 +-=0D
 tests/qemu-iotests/141                        |   1 +=0D
 tests/qemu-iotests/147                        |  13 +-=0D
 tests/qemu-iotests/148                        |   2 +=0D
 tests/qemu-iotests/149                        |   7 +-=0D
 tests/qemu-iotests/151                        |   6 +-=0D
 tests/qemu-iotests/152                        |   2 +=0D
 tests/qemu-iotests/155                        |   2 +=0D
 tests/qemu-iotests/163                        |  11 +-=0D
 tests/qemu-iotests/165                        |   3 +-=0D
 tests/qemu-iotests/194                        |   7 +-=0D
 tests/qemu-iotests/196                        |   2 +=0D
 tests/qemu-iotests/202                        |   1 +=0D
 tests/qemu-iotests/203                        |   1 +=0D
 tests/qemu-iotests/205                        |  11 +-=0D
 tests/qemu-iotests/206                        |   1 +=0D
 tests/qemu-iotests/207                        |   6 +-=0D
 tests/qemu-iotests/208                        |   1 +=0D
 tests/qemu-iotests/209                        |  11 +-=0D
 tests/qemu-iotests/210                        |   1 +=0D
 tests/qemu-iotests/211                        |   1 +=0D
 tests/qemu-iotests/212                        |   1 +=0D
 tests/qemu-iotests/213                        |   1 +=0D
 tests/qemu-iotests/216                        |   1 +=0D
 tests/qemu-iotests/218                        |   1 +=0D
 tests/qemu-iotests/219                        |   1 +=0D
 tests/qemu-iotests/224                        |  13 +-=0D
 tests/qemu-iotests/228                        |  11 +-=0D
 tests/qemu-iotests/234                        |   4 +-=0D
 tests/qemu-iotests/235                        |  14 +-=0D
 tests/qemu-iotests/236                        |   1 +=0D
 tests/qemu-iotests/237                        |   2 +=0D
 tests/qemu-iotests/238                        |   3 +-=0D
 tests/qemu-iotests/240                        |   2 +-=0D
 tests/qemu-iotests/242                        |  23 +-=0D
 tests/qemu-iotests/245                        |   1 +=0D
 tests/qemu-iotests/246                        |   1 +=0D
 tests/qemu-iotests/248                        |  12 +-=0D
 tests/qemu-iotests/254                        |   3 +-=0D
 tests/qemu-iotests/255                        |   1 +=0D
 tests/qemu-iotests/256                        |   4 +-=0D
 tests/qemu-iotests/257                        |  28 +-=0D
 tests/qemu-iotests/258                        |  10 +-=0D
 tests/qemu-iotests/260                        |   8 +-=0D
 tests/qemu-iotests/262                        |   4 +-=0D
 tests/qemu-iotests/264                        |   7 +-=0D
 tests/qemu-iotests/274                        |   1 +=0D
 tests/qemu-iotests/277                        |  10 +-=0D
 tests/qemu-iotests/280                        |   2 +-=0D
 tests/qemu-iotests/281                        |   4 +-=0D
 tests/qemu-iotests/283                        |   1 +=0D
 tests/qemu-iotests/295                        |   6 +-=0D
 tests/qemu-iotests/296                        |   7 +-=0D
 tests/qemu-iotests/297                        |   8 +-=0D
 tests/qemu-iotests/298                        |   2 +=0D
 tests/qemu-iotests/299                        |   1 +=0D
 tests/qemu-iotests/300                        |  10 +-=0D
 tests/qemu-iotests/302                        |   4 +-=0D
 tests/qemu-iotests/303                        |  13 +-=0D
 tests/qemu-iotests/304                        |   3 +-=0D
 tests/qemu-iotests/307                        |   2 +-=0D
 tests/qemu-iotests/310                        |   1 +=0D
 tests/qemu-iotests/check                      |   7 +-=0D
 tests/qemu-iotests/fat16.py                   |  12 +-=0D
 tests/qemu-iotests/findtests.py               |  19 +-=0D
 tests/qemu-iotests/iotests.py                 |  70 +++--=0D
 tests/qemu-iotests/linters.py                 |   9 +-=0D
 tests/qemu-iotests/nbd-fault-injector.py      |  13 +-=0D
 tests/qemu-iotests/qcow2.py                   |   5 +-=0D
 tests/qemu-iotests/qcow2_format.py            |  14 +-=0D
 tests/qemu-iotests/qed.py                     |  10 +-=0D
 tests/qemu-iotests/testenv.py                 |  25 +-=0D
 tests/qemu-iotests/testrunner.py              |  32 +--=0D
 tests/qemu-iotests/tests/block-status-cache   |   1 +=0D
 .../tests/export-incoming-iothread            |   1 +=0D
 .../qemu-iotests/tests/graph-changes-while-io |  11 +-=0D
 tests/qemu-iotests/tests/image-fleecing       |   1 +=0D
 tests/qemu-iotests/tests/inactive-node-nbd    |   8 +-=0D
 .../tests/iothreads-commit-active             |   2 +=0D
 tests/qemu-iotests/tests/iothreads-create     |   2 +=0D
 tests/qemu-iotests/tests/iothreads-nbd-export |   3 +=0D
 tests/qemu-iotests/tests/iothreads-stream     |   2 +=0D
 tests/qemu-iotests/tests/luks-detached-header |   5 +-=0D
 .../tests/migrate-bitmaps-postcopy-test       |  10 +-=0D
 tests/qemu-iotests/tests/migrate-bitmaps-test |   2 +-=0D
 .../qemu-iotests/tests/migrate-during-backup  |   1 +=0D
 .../tests/mirror-change-copy-mode             |   3 +-=0D
 .../tests/mirror-ready-cancel-error           |   1 +=0D
 tests/qemu-iotests/tests/nbd-multiconn        |   2 +-=0D
 .../qemu-iotests/tests/nbd-reconnect-on-open  |  11 +-=0D
 .../qemu-iotests/tests/parallels-read-bitmap  |   8 +-=0D
 tests/qemu-iotests/tests/qsd-migrate          |   2 +-=0D
 .../tests/remove-bitmap-from-backing          |   8 +-=0D
 tests/qemu-iotests/tests/reopen-file          |   3 +-=0D
 .../qemu-iotests/tests/stream-error-on-reset  |   8 +-=0D
 .../tests/stream-unaligned-prefetch           |  13 +-=0D
 .../qemu-iotests/tests/stream-under-throttle  |   4 +-=0D
 tests/qemu-iotests/tests/vvfat                |   7 +-=0D
 tests/tcg/aarch64/gdbstub/test-mte.py         |   2 +-=0D
 tests/tcg/aarch64/gdbstub/test-sve-ioctl.py   |   4 +-=0D
 tests/tcg/aarch64/gdbstub/test-sve.py         |   2 +-=0D
 tests/tcg/i386/test-avx.py                    |  11 +-=0D
 tests/tcg/i386/test-mmx.py                    |   9 +-=0D
 tests/tcg/multiarch/gdbstub/catch-syscalls.py |   6 +-=0D
 .../gdbstub/follow-fork-mode-child.py         |   4 +-=0D
 .../gdbstub/follow-fork-mode-parent.py        |   2 +-=0D
 tests/tcg/multiarch/gdbstub/interrupt.py      |   1 -=0D
 tests/tcg/multiarch/gdbstub/late-attach.py    |   4 +-=0D
 tests/tcg/multiarch/gdbstub/memory.py         |   2 -=0D
 tests/tcg/multiarch/gdbstub/prot-none.py      |   5 +-=0D
 tests/tcg/multiarch/gdbstub/registers.py      |   3 +-=0D
 tests/tcg/multiarch/gdbstub/sha1.py           |   1 -=0D
 .../multiarch/gdbstub/test-proc-mappings.py   |   1 -=0D
 .../multiarch/gdbstub/test-qxfer-auxv-read.py |   1 -=0D
 .../gdbstub/test-qxfer-siginfo-read.py        |   2 +-=0D
 .../gdbstub/test-thread-breakpoint.py         |   1 -=0D
 .../system/validate-memory-counts.py          |   7 +-=0D
 tests/tcg/s390x/gdbstub/test-signals-s390x.py |   2 -=0D
 tests/tcg/s390x/gdbstub/test-svc.py           |   1 -=0D
 tests/vm/aarch64vm.py                         |  16 +-=0D
 tests/vm/basevm.py                            |  37 +--=0D
 tests/vm/centos.aarch64                       |  11 +-=0D
 tests/vm/freebsd                              |   7 +-=0D
 tests/vm/haiku.x86_64                         |   7 +-=0D
 tests/vm/netbsd                               |   5 +-=0D
 tests/vm/openbsd                              |   5 +-=0D
 tests/vm/ubuntu.aarch64                       |   6 +-=0D
 tests/vm/ubuntuvm.py                          |   6 +-=0D
 456 files changed, 2624 insertions(+), 2058 deletions(-)=0D
 create mode 100644 python/pyproject.toml=0D
 delete mode 100755 python/setup.py=0D
=0D
-- =0D
2.48.1=0D
=0D


