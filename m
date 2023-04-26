Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F85C6EF64C
	for <lists+kvm@lfdr.de>; Wed, 26 Apr 2023 16:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241372AbjDZOV5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 26 Apr 2023 10:21:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241366AbjDZOVw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 26 Apr 2023 10:21:52 -0400
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB8172A3
        for <kvm@vger.kernel.org>; Wed, 26 Apr 2023 07:21:30 -0700 (PDT)
Received: from pps.filterd (m0353727.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33QEL3UM030067;
        Wed, 26 Apr 2023 14:21:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : content-transfer-encoding : mime-version; s=pp1;
 bh=5kPGS8qkDy+KuyCTBPlpH7TRxXrhatwoAag5qXa6fnI=;
 b=WCHKlb602sl906LfHI8togpPEvbOBUFKFS2qvLEl2pop9MewJoSD1WynMlSoyLh290Ii
 Cl1lrEhco9YSu5IVxLbttKzmvSixENxseugWLb6lb9AwZkCOhwPaqCT0Zfer39R9Nu6l
 iGdsEG7u90Yr8uoLDufGt6LuE2kzRQbs4wdbHZ/hRozaq11Axlg9BUU+xPJgKTiz4mf6
 OkimDthKg4CbZ0hv3ycdErSPF8ZLi/DNpj+D7lvsmqAuBVb8ey4pGwCgEe92yH2NOvZS
 VSfcJQ1wGh1ckeCLCc9cwfHdXQmkhISxV6OeoDweArnnApC3+ho7SPBXkEbyNLg+QnT2 Bg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q759uh5xt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 14:21:24 +0000
Received: from m0353727.ppops.net (m0353727.ppops.net [127.0.0.1])
        by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 33QDvku6027896;
        Wed, 26 Apr 2023 14:21:23 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3q759uh5v5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 14:21:23 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 33QDu6J2032055;
        Wed, 26 Apr 2023 14:08:08 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
        by ppma03ams.nl.ibm.com (PPS) with ESMTPS id 3q47772d2c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 26 Apr 2023 14:08:08 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
        by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 33QE864t4522600
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 Apr 2023 14:08:06 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7337320043;
        Wed, 26 Apr 2023 14:08:06 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1ED3820040;
        Wed, 26 Apr 2023 14:08:06 +0000 (GMT)
Received: from a46lp73.lnxne.boe (unknown [9.152.108.100])
        by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
        Wed, 26 Apr 2023 14:08:06 +0000 (GMT)
From:   Steffen Eiden <seiden@linux.ibm.com>
To:     kvm@vger.kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Thomas Huth <thuth@redhat.com>,
        Andrew Jones <andrew.jones@linux.dev>
Subject: [kvm-unit-tests PATCH] clang-format: add project-wide configuration file
Date:   Wed, 26 Apr 2023 16:08:05 +0200
Message-Id: <20230426140805.704491-1-seiden@linux.ibm.com>
X-Mailer: git-send-email 2.39.2
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: KgEe3-ugpkJBavWo79BlgM2E6mxwWETr
X-Proofpoint-GUID: utHYMiuiZDppgJyMSEv0STf2caIjiZNQ
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-26_06,2023-04-26_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 priorityscore=1501 mlxlogscore=999 clxscore=1011 bulkscore=0
 malwarescore=0 spamscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304260125
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

clang-format is a tool to format C/C++/... code according to a set of
rules and heuristics.

This commit adds the configuration file, with the setting the
Linux kernel project uses "as of today", with the modification
of allowing up to 120 chars per line.

This hopefully eases code formatting for developers, as clang-format
has support for most editors and also can be run standalone.

Additional information:
    https://clang.llvm.org/docs/ClangFormat.html
    https://clang.llvm.org/docs/ClangFormatStyleOptions.html

Signed-off-by: Steffen Eiden <seiden@linux.ibm.com>
---
 .clang-format | 688 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 688 insertions(+)
 create mode 100644 .clang-format

diff --git a/.clang-format b/.clang-format
new file mode 100644
index 0000000..71c7830
--- /dev/null
+++ b/.clang-format
@@ -0,0 +1,688 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# clang-format configuration file. Intended for clang-format >= 11.
+#
+# For more information, see:
+#
+#   Documentation/process/clang-format.rst
+#   https://clang.llvm.org/docs/ClangFormat.html
+#   https://clang.llvm.org/docs/ClangFormatStyleOptions.html
+#
+---
+AccessModifierOffset: -4
+AlignAfterOpenBracket: Align
+AlignConsecutiveAssignments: false
+AlignConsecutiveDeclarations: false
+AlignEscapedNewlines: Left
+AlignOperands: true
+AlignTrailingComments: false
+AllowAllParametersOfDeclarationOnNextLine: false
+AllowShortBlocksOnASingleLine: false
+AllowShortCaseLabelsOnASingleLine: false
+AllowShortFunctionsOnASingleLine: None
+AllowShortIfStatementsOnASingleLine: false
+AllowShortLoopsOnASingleLine: false
+AlwaysBreakAfterDefinitionReturnType: None
+AlwaysBreakAfterReturnType: None
+AlwaysBreakBeforeMultilineStrings: false
+AlwaysBreakTemplateDeclarations: false
+BinPackArguments: true
+BinPackParameters: true
+BraceWrapping:
+  AfterClass: false
+  AfterControlStatement: false
+  AfterEnum: false
+  AfterFunction: true
+  AfterNamespace: true
+  AfterObjCDeclaration: false
+  AfterStruct: false
+  AfterUnion: false
+  AfterExternBlock: false
+  BeforeCatch: false
+  BeforeElse: false
+  IndentBraces: false
+  SplitEmptyFunction: true
+  SplitEmptyRecord: true
+  SplitEmptyNamespace: true
+BreakBeforeBinaryOperators: None
+BreakBeforeBraces: Custom
+BreakBeforeInheritanceComma: false
+BreakBeforeTernaryOperators: false
+BreakConstructorInitializersBeforeComma: false
+BreakConstructorInitializers: BeforeComma
+BreakAfterJavaFieldAnnotations: false
+BreakStringLiterals: false
+ColumnLimit: 120
+CommentPragmas: '^ IWYU pragma:'
+CompactNamespaces: false
+ConstructorInitializerAllOnOneLineOrOnePerLine: false
+ConstructorInitializerIndentWidth: 8
+ContinuationIndentWidth: 8
+Cpp11BracedListStyle: false
+DerivePointerAlignment: false
+DisableFormat: false
+ExperimentalAutoDetectBinPacking: false
+FixNamespaceComments: false
+
+# Taken from:
+#   git grep -h '^#define [^[:space:]]*for_each[^[:space:]]*(' include/ tools/ \
+#   | sed "s,^#define \([^[:space:]]*for_each[^[:space:]]*\)(.*$,  - '\1'," \
+#   | LC_ALL=C sort -u
+ForEachMacros:
+  - '__ata_qc_for_each'
+  - '__bio_for_each_bvec'
+  - '__bio_for_each_segment'
+  - '__evlist__for_each_entry'
+  - '__evlist__for_each_entry_continue'
+  - '__evlist__for_each_entry_from'
+  - '__evlist__for_each_entry_reverse'
+  - '__evlist__for_each_entry_safe'
+  - '__for_each_mem_range'
+  - '__for_each_mem_range_rev'
+  - '__for_each_thread'
+  - '__hlist_for_each_rcu'
+  - '__map__for_each_symbol_by_name'
+  - '__perf_evlist__for_each_entry'
+  - '__perf_evlist__for_each_entry_reverse'
+  - '__perf_evlist__for_each_entry_safe'
+  - '__rq_for_each_bio'
+  - '__shost_for_each_device'
+  - 'apei_estatus_for_each_section'
+  - 'ata_for_each_dev'
+  - 'ata_for_each_link'
+  - 'ata_qc_for_each'
+  - 'ata_qc_for_each_raw'
+  - 'ata_qc_for_each_with_internal'
+  - 'ax25_for_each'
+  - 'ax25_uid_for_each'
+  - 'bio_for_each_bvec'
+  - 'bio_for_each_bvec_all'
+  - 'bio_for_each_folio_all'
+  - 'bio_for_each_integrity_vec'
+  - 'bio_for_each_segment'
+  - 'bio_for_each_segment_all'
+  - 'bio_list_for_each'
+  - 'bip_for_each_vec'
+  - 'bond_for_each_slave'
+  - 'bond_for_each_slave_rcu'
+  - 'bpf__perf_for_each_map'
+  - 'bpf__perf_for_each_map_named'
+  - 'bpf_for_each_spilled_reg'
+  - 'bpf_object__for_each_map'
+  - 'bpf_object__for_each_program'
+  - 'bpf_object__for_each_safe'
+  - 'bpf_perf_object__for_each'
+  - 'btree_for_each_safe128'
+  - 'btree_for_each_safe32'
+  - 'btree_for_each_safe64'
+  - 'btree_for_each_safel'
+  - 'card_for_each_dev'
+  - 'cgroup_taskset_for_each'
+  - 'cgroup_taskset_for_each_leader'
+  - 'cpufreq_for_each_efficient_entry_idx'
+  - 'cpufreq_for_each_entry'
+  - 'cpufreq_for_each_entry_idx'
+  - 'cpufreq_for_each_valid_entry'
+  - 'cpufreq_for_each_valid_entry_idx'
+  - 'css_for_each_child'
+  - 'css_for_each_descendant_post'
+  - 'css_for_each_descendant_pre'
+  - 'damon_for_each_region'
+  - 'damon_for_each_region_safe'
+  - 'damon_for_each_scheme'
+  - 'damon_for_each_scheme_safe'
+  - 'damon_for_each_target'
+  - 'damon_for_each_target_safe'
+  - 'data__for_each_file'
+  - 'data__for_each_file_new'
+  - 'data__for_each_file_start'
+  - 'device_for_each_child_node'
+  - 'displayid_iter_for_each'
+  - 'dma_fence_array_for_each'
+  - 'dma_fence_chain_for_each'
+  - 'dma_fence_unwrap_for_each'
+  - 'dma_resv_for_each_fence'
+  - 'dma_resv_for_each_fence_unlocked'
+  - 'do_for_each_ftrace_op'
+  - 'drm_atomic_crtc_for_each_plane'
+  - 'drm_atomic_crtc_state_for_each_plane'
+  - 'drm_atomic_crtc_state_for_each_plane_state'
+  - 'drm_atomic_for_each_plane_damage'
+  - 'drm_client_for_each_connector_iter'
+  - 'drm_client_for_each_modeset'
+  - 'drm_connector_for_each_possible_encoder'
+  - 'drm_for_each_bridge_in_chain'
+  - 'drm_for_each_connector_iter'
+  - 'drm_for_each_crtc'
+  - 'drm_for_each_crtc_reverse'
+  - 'drm_for_each_encoder'
+  - 'drm_for_each_encoder_mask'
+  - 'drm_for_each_fb'
+  - 'drm_for_each_legacy_plane'
+  - 'drm_for_each_plane'
+  - 'drm_for_each_plane_mask'
+  - 'drm_for_each_privobj'
+  - 'drm_mm_for_each_hole'
+  - 'drm_mm_for_each_node'
+  - 'drm_mm_for_each_node_in_range'
+  - 'drm_mm_for_each_node_safe'
+  - 'dsa_switch_for_each_available_port'
+  - 'dsa_switch_for_each_cpu_port'
+  - 'dsa_switch_for_each_port'
+  - 'dsa_switch_for_each_port_continue_reverse'
+  - 'dsa_switch_for_each_port_safe'
+  - 'dsa_switch_for_each_user_port'
+  - 'dsa_tree_for_each_user_port'
+  - 'dso__for_each_symbol'
+  - 'dsos__for_each_with_build_id'
+  - 'elf_hash_for_each_possible'
+  - 'elf_section__for_each_rel'
+  - 'elf_section__for_each_rela'
+  - 'elf_symtab__for_each_symbol'
+  - 'evlist__for_each_cpu'
+  - 'evlist__for_each_entry'
+  - 'evlist__for_each_entry_continue'
+  - 'evlist__for_each_entry_from'
+  - 'evlist__for_each_entry_reverse'
+  - 'evlist__for_each_entry_safe'
+  - 'flow_action_for_each'
+  - 'for_each_acpi_dev_match'
+  - 'for_each_active_dev_scope'
+  - 'for_each_active_drhd_unit'
+  - 'for_each_active_iommu'
+  - 'for_each_active_route'
+  - 'for_each_aggr_pgid'
+  - 'for_each_available_child_of_node'
+  - 'for_each_bench'
+  - 'for_each_bio'
+  - 'for_each_board_func_rsrc'
+  - 'for_each_btf_ext_rec'
+  - 'for_each_btf_ext_sec'
+  - 'for_each_bvec'
+  - 'for_each_card_auxs'
+  - 'for_each_card_auxs_safe'
+  - 'for_each_card_components'
+  - 'for_each_card_dapms'
+  - 'for_each_card_pre_auxs'
+  - 'for_each_card_prelinks'
+  - 'for_each_card_rtds'
+  - 'for_each_card_rtds_safe'
+  - 'for_each_card_widgets'
+  - 'for_each_card_widgets_safe'
+  - 'for_each_cgroup_storage_type'
+  - 'for_each_child_of_node'
+  - 'for_each_clear_bit'
+  - 'for_each_clear_bit_from'
+  - 'for_each_clear_bitrange'
+  - 'for_each_clear_bitrange_from'
+  - 'for_each_cmd'
+  - 'for_each_cmsghdr'
+  - 'for_each_collection'
+  - 'for_each_comp_order'
+  - 'for_each_compatible_node'
+  - 'for_each_component_dais'
+  - 'for_each_component_dais_safe'
+  - 'for_each_console'
+  - 'for_each_console_srcu'
+  - 'for_each_cpu'
+  - 'for_each_cpu_and'
+  - 'for_each_cpu_wrap'
+  - 'for_each_dapm_widgets'
+  - 'for_each_dedup_cand'
+  - 'for_each_dev_addr'
+  - 'for_each_dev_scope'
+  - 'for_each_dma_cap_mask'
+  - 'for_each_dpcm_be'
+  - 'for_each_dpcm_be_rollback'
+  - 'for_each_dpcm_be_safe'
+  - 'for_each_dpcm_fe'
+  - 'for_each_drhd_unit'
+  - 'for_each_dss_dev'
+  - 'for_each_efi_memory_desc'
+  - 'for_each_efi_memory_desc_in_map'
+  - 'for_each_element'
+  - 'for_each_element_extid'
+  - 'for_each_element_id'
+  - 'for_each_endpoint_of_node'
+  - 'for_each_event'
+  - 'for_each_event_tps'
+  - 'for_each_evictable_lru'
+  - 'for_each_fib6_node_rt_rcu'
+  - 'for_each_fib6_walker_rt'
+  - 'for_each_free_mem_pfn_range_in_zone'
+  - 'for_each_free_mem_pfn_range_in_zone_from'
+  - 'for_each_free_mem_range'
+  - 'for_each_free_mem_range_reverse'
+  - 'for_each_func_rsrc'
+  - 'for_each_group_evsel'
+  - 'for_each_group_member'
+  - 'for_each_hstate'
+  - 'for_each_if'
+  - 'for_each_inject_fn'
+  - 'for_each_insn'
+  - 'for_each_insn_prefix'
+  - 'for_each_intid'
+  - 'for_each_iommu'
+  - 'for_each_ip_tunnel_rcu'
+  - 'for_each_irq_nr'
+  - 'for_each_lang'
+  - 'for_each_link_codecs'
+  - 'for_each_link_cpus'
+  - 'for_each_link_platforms'
+  - 'for_each_lru'
+  - 'for_each_matching_node'
+  - 'for_each_matching_node_and_match'
+  - 'for_each_mem_pfn_range'
+  - 'for_each_mem_range'
+  - 'for_each_mem_range_rev'
+  - 'for_each_mem_region'
+  - 'for_each_member'
+  - 'for_each_memory'
+  - 'for_each_migratetype_order'
+  - 'for_each_missing_reg'
+  - 'for_each_net'
+  - 'for_each_net_continue_reverse'
+  - 'for_each_net_rcu'
+  - 'for_each_netdev'
+  - 'for_each_netdev_continue'
+  - 'for_each_netdev_continue_rcu'
+  - 'for_each_netdev_continue_reverse'
+  - 'for_each_netdev_feature'
+  - 'for_each_netdev_in_bond_rcu'
+  - 'for_each_netdev_rcu'
+  - 'for_each_netdev_reverse'
+  - 'for_each_netdev_safe'
+  - 'for_each_new_connector_in_state'
+  - 'for_each_new_crtc_in_state'
+  - 'for_each_new_mst_mgr_in_state'
+  - 'for_each_new_plane_in_state'
+  - 'for_each_new_plane_in_state_reverse'
+  - 'for_each_new_private_obj_in_state'
+  - 'for_each_new_reg'
+  - 'for_each_node'
+  - 'for_each_node_by_name'
+  - 'for_each_node_by_type'
+  - 'for_each_node_mask'
+  - 'for_each_node_state'
+  - 'for_each_node_with_cpus'
+  - 'for_each_node_with_property'
+  - 'for_each_nonreserved_multicast_dest_pgid'
+  - 'for_each_of_allnodes'
+  - 'for_each_of_allnodes_from'
+  - 'for_each_of_cpu_node'
+  - 'for_each_of_pci_range'
+  - 'for_each_old_connector_in_state'
+  - 'for_each_old_crtc_in_state'
+  - 'for_each_old_mst_mgr_in_state'
+  - 'for_each_old_plane_in_state'
+  - 'for_each_old_private_obj_in_state'
+  - 'for_each_oldnew_connector_in_state'
+  - 'for_each_oldnew_crtc_in_state'
+  - 'for_each_oldnew_mst_mgr_in_state'
+  - 'for_each_oldnew_plane_in_state'
+  - 'for_each_oldnew_plane_in_state_reverse'
+  - 'for_each_oldnew_private_obj_in_state'
+  - 'for_each_online_cpu'
+  - 'for_each_online_node'
+  - 'for_each_online_pgdat'
+  - 'for_each_path'
+  - 'for_each_pci_bridge'
+  - 'for_each_pci_dev'
+  - 'for_each_pcm_streams'
+  - 'for_each_physmem_range'
+  - 'for_each_populated_zone'
+  - 'for_each_possible_cpu'
+  - 'for_each_present_cpu'
+  - 'for_each_prime_number'
+  - 'for_each_prime_number_from'
+  - 'for_each_probe_cache_entry'
+  - 'for_each_process'
+  - 'for_each_process_thread'
+  - 'for_each_prop_codec_conf'
+  - 'for_each_prop_dai_codec'
+  - 'for_each_prop_dai_cpu'
+  - 'for_each_prop_dlc_codecs'
+  - 'for_each_prop_dlc_cpus'
+  - 'for_each_prop_dlc_platforms'
+  - 'for_each_property_of_node'
+  - 'for_each_reg'
+  - 'for_each_reg_filtered'
+  - 'for_each_registered_fb'
+  - 'for_each_requested_gpio'
+  - 'for_each_requested_gpio_in_range'
+  - 'for_each_reserved_mem_range'
+  - 'for_each_reserved_mem_region'
+  - 'for_each_rtd_codec_dais'
+  - 'for_each_rtd_components'
+  - 'for_each_rtd_cpu_dais'
+  - 'for_each_rtd_dais'
+  - 'for_each_script'
+  - 'for_each_sec'
+  - 'for_each_set_bit'
+  - 'for_each_set_bit_from'
+  - 'for_each_set_bitrange'
+  - 'for_each_set_bitrange_from'
+  - 'for_each_set_clump8'
+  - 'for_each_sg'
+  - 'for_each_sg_dma_page'
+  - 'for_each_sg_page'
+  - 'for_each_sgtable_dma_page'
+  - 'for_each_sgtable_dma_sg'
+  - 'for_each_sgtable_page'
+  - 'for_each_sgtable_sg'
+  - 'for_each_shell_test'
+  - 'for_each_sibling_event'
+  - 'for_each_subelement'
+  - 'for_each_subelement_extid'
+  - 'for_each_subelement_id'
+  - 'for_each_sublist'
+  - 'for_each_subsystem'
+  - 'for_each_supported_activate_fn'
+  - 'for_each_supported_inject_fn'
+  - 'for_each_test'
+  - 'for_each_thread'
+  - 'for_each_token'
+  - 'for_each_unicast_dest_pgid'
+  - 'for_each_vsi'
+  - 'for_each_wakeup_source'
+  - 'for_each_zone'
+  - 'for_each_zone_zonelist'
+  - 'for_each_zone_zonelist_nodemask'
+  - 'func_for_each_insn'
+  - 'fwnode_for_each_available_child_node'
+  - 'fwnode_for_each_child_node'
+  - 'fwnode_graph_for_each_endpoint'
+  - 'gadget_for_each_ep'
+  - 'genradix_for_each'
+  - 'genradix_for_each_from'
+  - 'hash_for_each'
+  - 'hash_for_each_possible'
+  - 'hash_for_each_possible_rcu'
+  - 'hash_for_each_possible_rcu_notrace'
+  - 'hash_for_each_possible_safe'
+  - 'hash_for_each_rcu'
+  - 'hash_for_each_safe'
+  - 'hashmap__for_each_entry'
+  - 'hashmap__for_each_entry_safe'
+  - 'hashmap__for_each_key_entry'
+  - 'hashmap__for_each_key_entry_safe'
+  - 'hctx_for_each_ctx'
+  - 'hists__for_each_format'
+  - 'hists__for_each_sort_list'
+  - 'hlist_bl_for_each_entry'
+  - 'hlist_bl_for_each_entry_rcu'
+  - 'hlist_bl_for_each_entry_safe'
+  - 'hlist_for_each'
+  - 'hlist_for_each_entry'
+  - 'hlist_for_each_entry_continue'
+  - 'hlist_for_each_entry_continue_rcu'
+  - 'hlist_for_each_entry_continue_rcu_bh'
+  - 'hlist_for_each_entry_from'
+  - 'hlist_for_each_entry_from_rcu'
+  - 'hlist_for_each_entry_rcu'
+  - 'hlist_for_each_entry_rcu_bh'
+  - 'hlist_for_each_entry_rcu_notrace'
+  - 'hlist_for_each_entry_safe'
+  - 'hlist_for_each_entry_srcu'
+  - 'hlist_for_each_safe'
+  - 'hlist_nulls_for_each_entry'
+  - 'hlist_nulls_for_each_entry_from'
+  - 'hlist_nulls_for_each_entry_rcu'
+  - 'hlist_nulls_for_each_entry_safe'
+  - 'i3c_bus_for_each_i2cdev'
+  - 'i3c_bus_for_each_i3cdev'
+  - 'idr_for_each_entry'
+  - 'idr_for_each_entry_continue'
+  - 'idr_for_each_entry_continue_ul'
+  - 'idr_for_each_entry_ul'
+  - 'in_dev_for_each_ifa_rcu'
+  - 'in_dev_for_each_ifa_rtnl'
+  - 'inet_bind_bucket_for_each'
+  - 'inet_lhash2_for_each_icsk'
+  - 'inet_lhash2_for_each_icsk_continue'
+  - 'inet_lhash2_for_each_icsk_rcu'
+  - 'interval_tree_for_each_double_span'
+  - 'interval_tree_for_each_span'
+  - 'intlist__for_each_entry'
+  - 'intlist__for_each_entry_safe'
+  - 'iopt_for_each_contig_area'
+  - 'kcore_copy__for_each_phdr'
+  - 'key_for_each'
+  - 'key_for_each_safe'
+  - 'klp_for_each_func'
+  - 'klp_for_each_func_safe'
+  - 'klp_for_each_func_static'
+  - 'klp_for_each_object'
+  - 'klp_for_each_object_safe'
+  - 'klp_for_each_object_static'
+  - 'kunit_suite_for_each_test_case'
+  - 'kvm_for_each_memslot'
+  - 'kvm_for_each_memslot_in_gfn_range'
+  - 'kvm_for_each_vcpu'
+  - 'libbpf_nla_for_each_attr'
+  - 'list_for_each'
+  - 'list_for_each_codec'
+  - 'list_for_each_codec_safe'
+  - 'list_for_each_continue'
+  - 'list_for_each_entry'
+  - 'list_for_each_entry_continue'
+  - 'list_for_each_entry_continue_rcu'
+  - 'list_for_each_entry_continue_reverse'
+  - 'list_for_each_entry_from'
+  - 'list_for_each_entry_from_rcu'
+  - 'list_for_each_entry_from_reverse'
+  - 'list_for_each_entry_lockless'
+  - 'list_for_each_entry_rcu'
+  - 'list_for_each_entry_reverse'
+  - 'list_for_each_entry_safe'
+  - 'list_for_each_entry_safe_continue'
+  - 'list_for_each_entry_safe_from'
+  - 'list_for_each_entry_safe_reverse'
+  - 'list_for_each_entry_srcu'
+  - 'list_for_each_from'
+  - 'list_for_each_prev'
+  - 'list_for_each_prev_safe'
+  - 'list_for_each_safe'
+  - 'llist_for_each'
+  - 'llist_for_each_entry'
+  - 'llist_for_each_entry_safe'
+  - 'llist_for_each_safe'
+  - 'map__for_each_symbol'
+  - 'map__for_each_symbol_by_name'
+  - 'map_for_each_event'
+  - 'map_for_each_metric'
+  - 'maps__for_each_entry'
+  - 'maps__for_each_entry_safe'
+  - 'mci_for_each_dimm'
+  - 'media_device_for_each_entity'
+  - 'media_device_for_each_intf'
+  - 'media_device_for_each_link'
+  - 'media_device_for_each_pad'
+  - 'msi_for_each_desc'
+  - 'nanddev_io_for_each_page'
+  - 'netdev_for_each_lower_dev'
+  - 'netdev_for_each_lower_private'
+  - 'netdev_for_each_lower_private_rcu'
+  - 'netdev_for_each_mc_addr'
+  - 'netdev_for_each_uc_addr'
+  - 'netdev_for_each_upper_dev_rcu'
+  - 'netdev_hw_addr_list_for_each'
+  - 'nft_rule_for_each_expr'
+  - 'nla_for_each_attr'
+  - 'nla_for_each_nested'
+  - 'nlmsg_for_each_attr'
+  - 'nlmsg_for_each_msg'
+  - 'nr_neigh_for_each'
+  - 'nr_neigh_for_each_safe'
+  - 'nr_node_for_each'
+  - 'nr_node_for_each_safe'
+  - 'of_for_each_phandle'
+  - 'of_property_for_each_string'
+  - 'of_property_for_each_u32'
+  - 'pci_bus_for_each_resource'
+  - 'pci_doe_for_each_off'
+  - 'pcl_for_each_chunk'
+  - 'pcl_for_each_segment'
+  - 'pcm_for_each_format'
+  - 'perf_config_items__for_each_entry'
+  - 'perf_config_sections__for_each_entry'
+  - 'perf_config_set__for_each_entry'
+  - 'perf_cpu_map__for_each_cpu'
+  - 'perf_evlist__for_each_entry'
+  - 'perf_evlist__for_each_entry_reverse'
+  - 'perf_evlist__for_each_entry_safe'
+  - 'perf_evlist__for_each_evsel'
+  - 'perf_evlist__for_each_mmap'
+  - 'perf_hpp_list__for_each_format'
+  - 'perf_hpp_list__for_each_format_safe'
+  - 'perf_hpp_list__for_each_sort_list'
+  - 'perf_hpp_list__for_each_sort_list_safe'
+  - 'perf_pmu__for_each_hybrid_pmu'
+  - 'ping_portaddr_for_each_entry'
+  - 'ping_portaddr_for_each_entry_rcu'
+  - 'plist_for_each'
+  - 'plist_for_each_continue'
+  - 'plist_for_each_entry'
+  - 'plist_for_each_entry_continue'
+  - 'plist_for_each_entry_safe'
+  - 'plist_for_each_safe'
+  - 'pnp_for_each_card'
+  - 'pnp_for_each_dev'
+  - 'protocol_for_each_card'
+  - 'protocol_for_each_dev'
+  - 'queue_for_each_hw_ctx'
+  - 'radix_tree_for_each_slot'
+  - 'radix_tree_for_each_tagged'
+  - 'rb_for_each'
+  - 'rbtree_postorder_for_each_entry_safe'
+  - 'rdma_for_each_block'
+  - 'rdma_for_each_port'
+  - 'rdma_umem_for_each_dma_block'
+  - 'resort_rb__for_each_entry'
+  - 'resource_list_for_each_entry'
+  - 'resource_list_for_each_entry_safe'
+  - 'rhl_for_each_entry_rcu'
+  - 'rhl_for_each_rcu'
+  - 'rht_for_each'
+  - 'rht_for_each_entry'
+  - 'rht_for_each_entry_from'
+  - 'rht_for_each_entry_rcu'
+  - 'rht_for_each_entry_rcu_from'
+  - 'rht_for_each_entry_safe'
+  - 'rht_for_each_from'
+  - 'rht_for_each_rcu'
+  - 'rht_for_each_rcu_from'
+  - 'rq_for_each_bvec'
+  - 'rq_for_each_segment'
+  - 'rq_list_for_each'
+  - 'rq_list_for_each_safe'
+  - 'scsi_for_each_prot_sg'
+  - 'scsi_for_each_sg'
+  - 'sctp_for_each_hentry'
+  - 'sctp_skb_for_each'
+  - 'sec_for_each_insn'
+  - 'sec_for_each_insn_continue'
+  - 'sec_for_each_insn_from'
+  - 'shdma_for_each_chan'
+  - 'shost_for_each_device'
+  - 'sk_for_each'
+  - 'sk_for_each_bound'
+  - 'sk_for_each_entry_offset_rcu'
+  - 'sk_for_each_from'
+  - 'sk_for_each_rcu'
+  - 'sk_for_each_safe'
+  - 'sk_nulls_for_each'
+  - 'sk_nulls_for_each_from'
+  - 'sk_nulls_for_each_rcu'
+  - 'snd_array_for_each'
+  - 'snd_pcm_group_for_each_entry'
+  - 'snd_soc_dapm_widget_for_each_path'
+  - 'snd_soc_dapm_widget_for_each_path_safe'
+  - 'snd_soc_dapm_widget_for_each_sink_path'
+  - 'snd_soc_dapm_widget_for_each_source_path'
+  - 'strlist__for_each_entry'
+  - 'strlist__for_each_entry_safe'
+  - 'sym_for_each_insn'
+  - 'sym_for_each_insn_continue_reverse'
+  - 'symbols__for_each_entry'
+  - 'tb_property_for_each'
+  - 'tcf_act_for_each_action'
+  - 'tcf_exts_for_each_action'
+  - 'udp_portaddr_for_each_entry'
+  - 'udp_portaddr_for_each_entry_rcu'
+  - 'usb_hub_for_each_child'
+  - 'v4l2_device_for_each_subdev'
+  - 'v4l2_m2m_for_each_dst_buf'
+  - 'v4l2_m2m_for_each_dst_buf_safe'
+  - 'v4l2_m2m_for_each_src_buf'
+  - 'v4l2_m2m_for_each_src_buf_safe'
+  - 'virtio_device_for_each_vq'
+  - 'while_for_each_ftrace_op'
+  - 'xa_for_each'
+  - 'xa_for_each_marked'
+  - 'xa_for_each_range'
+  - 'xa_for_each_start'
+  - 'xas_for_each'
+  - 'xas_for_each_conflict'
+  - 'xas_for_each_marked'
+  - 'xbc_array_for_each_value'
+  - 'xbc_for_each_key_value'
+  - 'xbc_node_for_each_array_value'
+  - 'xbc_node_for_each_child'
+  - 'xbc_node_for_each_key_value'
+  - 'xbc_node_for_each_subkey'
+  - 'zorro_for_each_dev'
+
+IncludeBlocks: Preserve
+IncludeCategories:
+  - Regex: '.*'
+    Priority: 1
+IncludeIsMainRegex: '(Test)?$'
+IndentCaseLabels: false
+IndentGotoLabels: false
+IndentPPDirectives: None
+IndentWidth: 8
+IndentWrappedFunctionNames: false
+JavaScriptQuotes: Leave
+JavaScriptWrapImports: true
+KeepEmptyLinesAtTheStartOfBlocks: false
+MacroBlockBegin: ''
+MacroBlockEnd: ''
+MaxEmptyLinesToKeep: 1
+NamespaceIndentation: None
+ObjCBinPackProtocolList: Auto
+ObjCBlockIndentWidth: 8
+ObjCSpaceAfterProperty: true
+ObjCSpaceBeforeProtocolList: true
+
+# Taken from git's rules
+PenaltyBreakAssignment: 10
+PenaltyBreakBeforeFirstCallParameter: 30
+PenaltyBreakComment: 10
+PenaltyBreakFirstLessLess: 0
+PenaltyBreakString: 10
+PenaltyExcessCharacter: 100
+PenaltyReturnTypeOnItsOwnLine: 60
+
+PointerAlignment: Right
+ReflowComments: false
+SortIncludes: false
+SortUsingDeclarations: false
+SpaceAfterCStyleCast: false
+SpaceAfterTemplateKeyword: true
+SpaceBeforeAssignmentOperators: true
+SpaceBeforeCtorInitializerColon: true
+SpaceBeforeInheritanceColon: true
+SpaceBeforeParens: ControlStatementsExceptForEachMacros
+SpaceBeforeRangeBasedForLoopColon: true
+SpaceInEmptyParentheses: false
+SpacesBeforeTrailingComments: 1
+SpacesInAngles: false
+SpacesInContainerLiterals: false
+SpacesInCStyleCastParentheses: false
+SpacesInParentheses: false
+SpacesInSquareBrackets: false
+Standard: Cpp03
+TabWidth: 8
+UseTab: Always
+...
-- 
2.39.2

